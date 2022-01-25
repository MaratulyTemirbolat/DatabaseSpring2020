import pyodbc 
from tkinter import *
conn = pyodbc.connect('Driver={SQL Server};'
                      'Server=DESKTOP-9VV7AM5;'
                      'Database=Market;'
                      'Trusted_Connection=yes;')
cursor = conn.cursor()
answer = 'exec spJust @number = 2'
cursor.execute(answer)
problem = ''
for row in cursor:
	row = list(row)
	for line in row:
		if('ERROR' in line):
			problem = line
			print('There is a problem')
	print(row,type(row))
if(len(problem) >0):
	LABEL
else:
	cursor.commit()
