# _*_ encoding: UTF-8 -*-
#!/usr/bin/python

Daily   = 1
Monthly = 2

import sys
from datetime import date, datetime, timedelta
import urllib2
import MySQLdb
import weather_settings.py

class Weather():

    def __init__ (self):
        self.Id             = 0
        self.Time           = datetime.now()
        self.Temperature    = 0.0
        self.DewPoint       = 0.0
        self.Humidity       = 0
        self.SeaLevelPressure = 0.0
        self.Visibility     = 0.0
        self.WindDirection  = None
        self.WindSpeed      = 0.0
        self.WindDegrees    = 0
        self.GustSpeed      = 0.0
        self.Precipitation  = 0.0
        self.Events         = None
        self.Conditions     = None
        self.DateUTC        = datetime.now()

    def __str__ (self):
		return self.Time.strftime('%Y-%m-%d %H:%M:%S')

def insert (weather):
    w = weather
    try:
        commandText = """INSERT INTO weather_zsss(time,
                                             temperature,
                                             dew_point,
                                             humidity,
                                             sea_level_pressure,
                                             visibility,
                                             wind_direction,
                                             wind_speed,
                                             wind_degrees,
                                             gust_speed,
                                             precipitation,
                                             events,
                                             conditions,
                                             date_utc)
                         VALUES(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"""
        t = (w.Time,
             w.Temperature,
             w.DewPoint,
             w.Humidity,
             w.SeaLevelPressure,
             w.Visibility,
             w.WindDirection,
             w.WindSpeed,
             w.WindDegrees,
             w.GustSpeed,
             w.Precipitation,
             w.Events,
             w.Conditions,
             w.DateUTC)
        conn = MySQLdb.connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DB, charset='utf8')
        with conn: 
            cur = conn.cursor() 
            cur.execute(commandText, t)
            # print(cur._last_executed)
    except MySQLdb.Error, e:
        print 'Error %d: %s' % (e.args[0], e.args[1])
        sys.exit(1)        


def delete (time0, time1):
    try:
        conn = MySQLdb.connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DB, charset='utf8')
        with conn: 
            cur = conn.cursor() 
            cur.execute('DELETE FROM weather_zsss WHERE Time >= %s AND Time <= %s', (time0, time1))
            # print(cur._last_executed)
    except MySQLdb.Error, e:
        print 'Error %d: %s' % (e.args[0], e.args[1])
        sys.exit(1)        

    # print 'Deleted date: %s' % time0

def GetUrl(date, code, wtype):
    root_path = 'http://www.wunderground.com'    
    monthly_path = 'MonthlyHistory.html'
    daily_path = 'DailyHistory.html'
    query_string = 'format=1'

    url = root_path
    url += '/history/station/%s' % code
    url += '/%d/%d/%d' % (date.year, date.month, date.day)
    url += '/%s?%s' % (daily_path if wtype == Daily else monthly_path, query_string)
    # print url
    return url

def LoadHtml(url):
    req = urllib2.Request(url)
    html = urllib2.urlopen(req).read()
    return html

def ParseHtml(html, date):
    str = datetime.strftime(date, '%Y-%m-%d')

    html = html.strip()
    html = html.replace('<br />','')
    rows = html.split('\n')
    weathers = []
    for row in rows:

        cells = row.split(',')

        # Skip the first row, its title
        if cells[0] == 'TimeCST':
            continue

        w = Weather()
        w.Time = datetime.strptime(str + ' ' + cells[0], '%Y-%m-%d %I:%M %p')
        w.Temperature = float(cells[1])
        w.DewPoint = float(cells[2])
        w.Humidity = float(cells[3])
        w.SeaLevelPressure = float(cells[4])
        w.Visibility = float(cells[5])
        w.WindDirection = cells[6]
        w.WindSpeed = -9999.0 if cells[7].isalpha() else float(cells[7])
        w.GustSpeed = 0.0 if cells[8] == '-' else float(cells[8])
        w.Precipitation = 0.0 if cells[9] == 'N/A' else float(cells[9])
        w.Events = cells[10]
        w.Conditions = cells[11]
        w.WindDegrees = int(cells[12])
        w.DateUTC = datetime.strptime(cells[13], '%Y-%m-%d %H:%M:%S')

        weathers.append(w)

    return weathers

if __name__ == '__main__':

    argc = len(sys.argv)
    if argc < 3:
        print 'Invalid arguments'
        sys.exit(1)
    
    time0 = datetime.strptime(sys.argv[1], '%Y-%m-%d')
    time1 = datetime.strptime(sys.argv[2], '%Y-%m-%d')
    print "From: %s, To: %s" % (time0, time1)
    
    #time0 = date(2013, 1, 1)
    #time1 = date(2013, 12, 31)
    #time1 = date.today()

    # increase step is one day
    delta = timedelta(1)
    while time0 <= time1:
        print time0
        url = GetUrl(time0, 'ZSSS', Daily) 
        html = LoadHtml(url)
        weathers = ParseHtml(html, time0)

        delete(time0, time1)
        for w in weathers:
            insert(w)

        time0 = time0 + delta 
