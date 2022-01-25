import pyodbc 

conn = pyodbc.connect('Driver={SQL Server};'
                      'Server=DESKTOP-9VV7AM5;'
                      'Database=Universities;'
                      'Trusted_Connection=yes;')

cursor = conn.cursor()
# cursor.execute('''CREATE FUNCTION checkPerson(@name varchar(50),@surname varchar(50))
# 				  returns varchar(5)
# 				  BEGIN
# 				  DECLARE @output varchar(5) = NULL
# 				  DECLARE @number int = (select count(*) from NameSurname where namePerson = @name AND surnamePerson = @surname);
# 				  if @number>0
# 				  BEGIN
# 				  SET @output = 'YES'
# 				  END
# 				  ELSE
# 				  BEGIN
# 				  SET @output  = 'NO'
# 				  END
# 				  return @output
# 				  END''')

cursor.execute('''select * from STUDENT;''')
var_fix = []
for row in cursor:
	var_fix.append(list(map(str,list(row))))

# for k in var_fix:
#     for j in k:
#     	j = j.replace('  ','')
# 		# print(j,end = ' || ')
# 	# print()
# 	# f.write(str(k))
# 	# print(k)
# 	# f.write('\n')
# # f.close()

conn.commit()