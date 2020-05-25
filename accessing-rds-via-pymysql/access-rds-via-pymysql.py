import sys
import logging
import extract_rds_info
import pymysql

rds_host = extract_rds_info.rds_info('generic-mysql-instances')['db_address']
name = extract_rds_info.rds_info('generic-mysql-instances')['db_user']
password = extract_rds_info.aws_secret_manager_get_secret_value('rds-credentials', 'SecretString', 'password')
db_name = extract_rds_info.rds_info('generic-mysql-instances')['db_name']

logger = logging.getLogger()
logger.setLevel(logging.INFO)

try:
    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=30)
    with conn.cursor() as cur:
        cur.execute("CREATE TABLE IF NOT EXISTS LinesCount ( \
                    id INT NOT NULL AUTO_INCREMENT, \
                    ObjectPath varchar(250) DEFAULT NULL, \
                    AmountOfLines INT DEFAULT NULL, \
                    Insertion_date datetime default CURRENT_TIMESTAMP, \
                    PRIMARY KEY (id) \
                ) ENGINE = INNODB")
        cur.execute("CREATE TABLE IF NOT EXISTS WordsCount ( \
                    ObjectPath varchar(250) DEFAULT NULL, \
                    AmountOfWords INT DEFAULT NULL, \
                    Insertion_date datetime default CURRENT_TIMESTAMP \
                ) ENGINE = INNODB")
        conn.commit()
except pymysql.MySQLError as e:
    logger.error("ERROR: Unexpected error: Could not connect to MySQL instance.")
    logger.error(e)
    sys.exit()

logger.info("SUCCESS: Connection to RDS MySQL instance succeeded")


# def handler(event, context):
#     """
#     This function fetches content from MySQL RDS instance
#     """
#
#     item_count = 0
#
#     with conn.cursor() as cur:
#         cur.execute("CREATE TABLE IF NOT EXISTS LinesCount ( \
#                     id INT NOT NULL AUTO_INCREMENT, \
#                     ObjectPath varchar(250) DEFAULT NULL, \
#                     AmountOfLines INT DEFAULT NULL, \
#                     Insertion_date datetime default CURRENT_TIMESTAMP, \
#                     PRIMARY KEY (id) \
#                 ) ENGINE = INNODB; \
#                 SHOW COLUMNS FROM LinesCount")
#         # cur.execute('insert into Employee (EmpID, Name) values(1, "Joe")')
#         # cur.execute('insert into Employee (EmpID, Name) values(2, "Bob")')
#         # cur.execute('insert into Employee (EmpID, Name) values(3, "Mary")')
#         conn.commit()
#         cur.execute("show tables from lambdalines")
#         for row in cur:
#             item_count += 1
#             logger.info(row)
#             # print(row)
#     conn.commit()
#
#     return "Added %d items from RDS MySQL table" % (item_count)
