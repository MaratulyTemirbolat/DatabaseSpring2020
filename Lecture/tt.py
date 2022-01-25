import pyodbc 
from tkinter import *
conn = pyodbc.connect('Driver={SQL Server};'
                      'Server=DESKTOP-9VV7AM5;'
                      'Database=Market;'
                      'Trusted_Connection=yes;')

cursor = conn.cursor()
cursorTwo = conn.cursor()
cursorThree = conn.cursor()
#cursor.execute('''CREATE TABLE NameSurname(
#          namePerson varchar(50),
#          surnamePerson varchar(50)
#             );''')

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

def commit():
	new_name = e1.get()
	new_surname = e2.get()
	new_name = '\'' + new_name + '\''
	new_surname = '\'' + new_surname + '\''
	answer = 'insert into NameSurname values (' + new_name + ','+ new_surname + ')'+';'
	print('You ARE successfully Added!')
	cursor.execute(answer)
	conn.commit()
def delete():
	new_name = e1.get()
	new_surname = e2.get()
	new_name = '\'' + new_name + '\''
	new_surname = '\'' + new_surname + '\''
	cursorTwo.execute('''IF dbo.checkPerson({},{}) LIKE 'YES'
					  BEGIN
					  	select 'EVERYTHING IS GOOD ! You are Deleted!'
						delete from NameSurname where namePerson = {} AND surnamePerson = {};
					  END
					  ELSE
					  BEGIN
						select 'SORRY, THERE IS NO SUCH PERSON!'
					  END'''.format(new_name,new_surname,new_name,new_surname))
	for row in cursorTwo:
		print(row)
	cursorTwo.execute('select * from NameSurname')
	for row in cursorTwo:
		print(row)
	conn.commit()
def update():
	new_name = e1.get()
	new_surname = e2.get()
	last_name = e3.get()
	last_surname = e4.get()
	new_name = '\'' + new_name + '\''
	new_surname = '\'' + new_surname + '\''
	last_name = '\'' + last_name + '\''
	last_surname = '\'' + last_surname + '\''
	cursorThree.execute('''IF dbo.checkPerson({},{}) LIKE 'YES'
					    BEGIN
					    	select 'EVERYTHING IS GOOD! You are ALTERED'
					   		UPDATE NameSurname
							SET namePerson = {},surnamePerson = {}
							where namePerson = {} AND surnamePerson = {}
							
						END
						ELSE
						BEGIN
							select 'SORRY, THERE IS NO SUCH PERSON!'
						END'''.format(new_name,new_surname,last_name,last_surname,new_name,new_surname))
	for row in cursorThree:
		print(row)
	cursorThree.execute('select * from NameSurname')
	for row in cursorThree:
		print(row)
	conn.commit()

window = Tk()
window.geometry('300x300')
e1 = Entry(window)
e2 = Entry(window)
e3 = Entry(window)
e4 = Entry(window)
l1 = Label(window, text='Name')
l2 = Label(window, text='Surname')
l3 = Label(window, text='New Name')
l4 = Label(window, text='New Surname')
b = Button(window, text='Submit', command=commit)
b1 = Button(window, text='Delete', command=delete)
b3 = Button(window, text='Update', command=update)
e1.focus()
l1.pack()
e1.pack()
l2.pack()
e2.pack()
b.pack()
b1.pack()
b3.pack()
l3.pack()
e3.pack()
l4.pack()
e4.pack()

window.mainloop()