#!/usr/bin/env python3

import datetime
import logging
import os

import mariadb


def get_config():
    host = os.getenv("RDS_HOST")

    if ":" in host:
        host, port = host.split(":")
    else:
        port = 3306

    return {
        "host": host,
        "port": port,
        "user": os.getenv("RDS_USER"),
        "pass": os.getenv("RDS_PASS"),
        "name": os.getenv("RDS_NAME"),
        "log": f"{os.getenv('MOUNT_POINT')}/{datetime.datetime.now().isoformat()}.log",
    }


def fetch_table_info(connection):
    cursor = connection.cursor()

    cursor.execute(
        "SELECT table_name, (data_length + index_length) FROM information_schema.TABLES WHERE data_length > 0"
    )

    output = dict()

    for table_name, table_length in cursor:
        output[table_name] = table_length

    return output


def optimize_tables(connection):
    connection.autocommit = False

    cursor = connection.cursor()

    cursor.execute(
        "SELECT table_name, (data_length + index_length) FROM information_schema.TABLES WHERE data_length > 0"
    )

    tables = cursor.fetchall()

    for table_name, table_length in tables:
        cursor.execute(f"ANALYZE TABLE {table_name} PERSISTENT FOR ALL;")
        cursor.execute(f"OPTIMIZE TABLE {table_name};")

    connection.commit()

    connection.autocommit = True


def build_table_log(passes):
    output = ["",
              " TABLE | BEFORE | AFTER ",
              " ----- | ------ | ----- "
    ]

    total = dict()

    for iteration in passes:
        if not total:
            total = dict.fromkeys(iteration, [])

        for table_name, table_length in iteration.items():
            total[table_name] = total[table_name] + [table_length]

    for table, length in total.items():
        output.append(f"{table} went from " + " to ".join(list(map(str, length))) + " bytes")

    return output


def main():
    config = get_config()

    logging.basicConfig(filename=config["log"], level=logging.INFO)

    try:
        rds = mariadb.connect(
            user=config["user"],
            password=config["pass"],
            host=config["host"],
            port=int(config["port"]),
            database=config["name"],
        )

        table_info = []
        table_info.append(fetch_table_info(rds))
        optimize_tables(rds)
        table_info.append(fetch_table_info(rds))

        logging.info("\n".join(build_table_log(table_info)))
    except mariadb.Error as e:
        logging.error(e)


if __name__ == "__main__":
    main()
