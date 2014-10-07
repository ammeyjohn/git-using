# _*_ encoding: UTF-8 -*-
#!/usr/bin/python

import sys
from datetime import date, datetime, timedelta
import urllib2
import MySQLdb
from weather_settings import *

def LoadData (st, et):
    try:
        commandText = """ SELECT * FROM weather_zsss WHERE Time >= %s AND Time
        <= %s """

        conn = MySQLdb.connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DB, charset='utf8')


    except MySQLdb.Error, e:
        print 'Error %d: %s' % (e.args[0], e.args[1])
        sys.exit(1)        

if __name__ == '__main__':
    print __name__
    print MYSQL_HOST
