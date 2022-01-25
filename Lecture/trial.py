import pyodbc 


conn = pyodbc.connect("Driver={SQL Server Native Client 11.0};"
                      "Server=DESKTOP-9VV7AM5;"
                      'Trusted_Connection=yes;')

cursor = conn.cursor()
cursor.execute('''select * from Universities.dbo.STUDENT;''')
var_fix = []
for row in cursor:
	var_fix.append(list(map(str,list(row))))
#f = open("C:/Users/temir/OneDrive/Рабочий стол/KBTU/Database/Practice/Exercises/Lab10/pythonFile.txt","a")

for k in var_fix:
	for j in k:
		j = j.replace('  ','')
		print(j,end = ' || ')
	print()
	# f.write(str(k))
	print(k)
	# f.write('\n')
# f.close()

#cursor.execute('select * from Market.dbo.vWVendorsProductsDetails')
#cursor.execute('select *, Market.dbo.sumOfZipNumbers(CAST(people.person_zip as varchar)) from Market.dbo.people')

#cursor.execute('insert into Market.dbo.vWVendorsProductsDetails values(\'Burg3\',\'Burger2\',20,\'3.49\',\'Very tasty burger again\',\'Bears R Us\')')


