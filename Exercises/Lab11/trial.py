from tkinter import *
import pyodbc 
from parameters import *
from tkinter import messagebox as mesBox

conn = pyodbc.connect('Driver={SQL Server};'
                       'Server=DESKTOP-9VV7AM5;'
                       'Database=usersdb;'
                       'Trusted_Connection=yes;')
cursor = conn.cursor()

class universitySystem:
	allTheUsers = []
	def __init__(self):
		self.allTheUsers = [Admin('1','Temirbolat','Maratuly','t_maratuly','Timka2019!'),User('2','Assanali','Moldash','a_moldash','Timka2019!')]
	def checkPassword(self,newPassword):
		requiredCharacters = ['.',',',':',';','?','!','*','+','%','-','<','>','@','[',']','{','}','/','_','$','#']
		leghtPassword = False
		latinAlphabet = False
		arabicNumbers = False 
		lowerCase = False
		upperCase = False
		isReqCharacter = False
		if(len(newPassword)>=8 and len(newPassword)<=14):
			leghtPassword = True
		for k in range(len(newPassword)):
			if((ord(newPassword[k]) >=65 and ord(newPassword[k])<=90) or (ord(newPassword[k])>=97 and ord(newPassword[k])<=122)):
				latinAlphabet = True
			elif(newPassword[k] in requiredCharacters):
				isReqCharacter = True
		for k in range(len(newPassword)):
			if(ord(newPassword[k])>=48 and ord(newPassword[k])<=57):
				arabicNumbers = True
			elif(newPassword[k].isupper() == True):
				upperCase = True
			elif(newPassword[k].islower() == True):
				lowerCase = True
		print(leghtPassword)
		print(latinAlphabet)
		print(arabicNumbers)
		print(lowerCase)
		print(upperCase)
		print(isReqCharacter)
		if(leghtPassword == True and latinAlphabet == True and arabicNumbers == True and  lowerCase == True and upperCase == True and isReqCharacter == True):
			return True
		return False
	def checkLogin(self,login):
		isThere = False
		for user in self.allTheUsers:
			if(user.getLogin() == login):
				isThere = True
		print('Is There:',isThere)
		return isThere
	def createUser(self,university,numberId,name,surname,login,passwrord):
		if(university.checkPassword(passwrord) == True and university.checkLogin(login) == False):
			newUser = User(numberId,name,surname,login,passwrord)
			self.allTheUsers.append(newUser)
		else:
			print('Sorry! You made a mistake in password format!')
	
	def findUser(self,login):
		user = None
		for curUser in self.allTheUsers:
			if(curUser.getLogin() == login):
				user = curUser
		return user 


class User:
	numberId = ""
	name = ""
	surname = ""
	login = ""
	paswword = ""
	def __init__(self,numberId,name,surname,login,paswword):
		self.numberId = numberId
		self.name = name
		self.surname = surname
		self.login = login
		self.paswword = paswword

	def getName(self):
		return self.name
	def getSurname(self):
		return self.surname
	def setName(self,name):
		self.name = name
	def setSurname(self,surname):
		self.surname = surname
	def getLogin(self):
		return self.login
	def setLogin(self,login):
		self.login = login
	def getPassword(self):
		return self.paswword
	def setPassword(self,paswword):
		self.paswword = paswword
	def getNumberId(self):
		return self.numberId;		

	def viewTable(self):
		cursor.execute("select * from users;")
		answer = ""
		for row in cursor:
			answer+=str(row)
			answer+='\n'
		return answer

	def isExistedLogin(self,login):
		if(university.findUser(login) == None):
			return False
		return True

class Admin(User):
	def __init__(self,numberId,name,surname,login,paswword):
		super().__init__(numberId,name,surname,login,paswword)

	def insertUser(self,numberId,name,surname,login,paswword):
		cursor.execute("insert into users values('{}','{}','{}','user','{}');".format(numberId,name,surname,login))
		university.allTheUsers.append(User(numberId,name,surname,login,paswword))
		conn.commit()


	def updateUser(self,numberId,name,surname,login):
		cursor.execute("""UPDATE users
					      SET userName = '{}',userSurname = '{}'
						  where numberId = '{}';""".format(name,surname,numberId))
		university.findUser(login).setName(name)
		university.findUser(login).setSurname(surname)
		conn.commit()

	def deleteUser(self,numberId,user):
		cursor.execute("DELETE FROM users WHERE numberId = '{}';".format(user.getNumberId()))
		university.allTheUsers.remove(user)
		conn.commit()



def enterSystem():
	enterredLogin = ent_l.get()
	enterredPassword = ent_p.get()
	if (university.findUser(enterredLogin) == None):
		mesBox.showerror('Error','There is no such User')
	
	else:
		myUser = university.findUser(enterredLogin)
		if(myUser.getPassword() != enterredPassword):
			if(type(myUser) == Admin):
				mesBox.showerror('Error','You can not enter Admin Account which is not your!')
			else:
				mesBox.showerror('Error','You can not enter User Account which is not your!')
		else:
			if(type(myUser) == Admin):
				adminInterface(myUser)
			else:	
				userInterface(myUser)

def viewTable(myUser):
	global grateFullOutput,outputLabel
	myOutput = myUser.viewTable()
	grateFullOutput = Label(window,text = 'All the Existed Users are : ',bg = "#856ff8",fg='#000000',font = ("Arial",11))
	outputLabel = Label(window,text = myOutput,bg = "#856ff8",fg='#000000',font = ("Arial",11))
	grateFullOutput.place(x = 60,y=270)
	outputLabel.place(x = 150,y = 290)

def deleteUserFinally(myAdmin):
	typedLogin = deleteUserLoginEntry.get()
	global showSuccessfullDeletion
	if (university.findUser(typedLogin) == None):
		mesBox.showerror('Error!','There is no such user!')
	else:
		foundUser = university.findUser(typedLogin)
		showSuccessfullDeletion = Label(window,text = 'The user {} with Id = {} and Login = {} is deleted successfully'.format(foundUser.getName(),foundUser.getNumberId(),foundUser.getLogin()))
		showSuccessfullDeletion.pack()
		myAdmin.deleteUser(foundUser.getNumberId(),foundUser)
		showSuccessfullDeletion.destroy()
		infoLabel.destroy()
		deleteUserLoginEntry.destroy()
		deleteUserB.destroy()
		adminInterface(myAdmin)


def deleteUser(myAdmin):
	global infoLabel,deleteUserLoginEntry,deleteUserB
	introLabel.destroy()
	viewPeopleButton.destroy()
	deleteButton.destroy()
	insertButton.destroy()
	updateButton.destroy()
	grateFullOutput.destroy()
	outputLabel.destroy()
	infoLabel = Label(window,text = 'Please, type the Login of the User which you want to delete:',font = ("Arial",12))
	deleteUserLoginEntry = Entry(window)
	deleteUserB = Button(window, text = 'Delete User',bg = "#ba181b",fg='#000000',font = ("Arial",12),command = lambda:deleteUserFinally(myAdmin))
	infoLabel.place(x = 40,y =170 )
	deleteUserLoginEntry.place(x =180 , y = 200 )
	deleteUserB.place(x = 195,y = 230)

#numberId,name,surname,login,paswword
#insertUser(self,numberId,name,surname,login,paswword)
def insertFinally(myAdmin,id,name,surname,login,paswword):
	if(university.checkPassword(paswword) == False):
		mesBox.showerror('Error!','The password is not Suitable!')
	else:
		foundUser = university.findUser(login)
		if(foundUser != None):
			mesBox.showerror('Error!','You can not add existed user!')
		else:
			myAdmin.insertUser(id,name,surname,login,paswword)
			infoLabelInsert.destroy()
			infoId.destroy()
			idEntry.destroy()
			infoName.destroy()
			nameEntry.destroy()
			infoSurname.destroy()
			surnameEntry.destroy()
			infoLogin.destroy()
			loginEntry.destroy()
			infoPassword.destroy()
			passwordEntry.destroy()
			insertB.destroy()
			adminInterface(myAdmin)

def insertUser(myAdmin):
	global infoLabelInsert,infoId,idEntry,infoName,nameEntry,infoSurname,surnameEntry,infoLogin,loginEntry,infoPassword,passwordEntry,insertB
	introLabel.destroy()
	viewPeopleButton.destroy()
	deleteButton.destroy()
	insertButton.destroy()
	updateButton.destroy()
	grateFullOutput.destroy()
	outputLabel.destroy()
	infoLabelInsert = Label(window,text = 'Please, type the User Id, User Name, User Surname, User Login, User Password:',font = ("Arial",10))
	infoId = Label(window,text= 'Id',font = ("Arial",10))
	idEntry = Entry(window)
	infoName = Label(window,text = 'Name',font = ("Arial",10))
	nameEntry = Entry(window)
	infoSurname = Label(window,text = 'Surname',font = ("Arial",10))
	surnameEntry = Entry(window)
	infoLogin = Label(window,text = 'Login',font = ("Arial",10))
	loginEntry = Entry(window)
	infoPassword = Label(window,text = 'Password',font = ("Arial",10))
	passwordEntry = Entry(window)
	insertB = Button(window,text = 'Insert',bg = "#43aa8b",fg='#000000',font = ("Arial",12),command = lambda:insertFinally(myAdmin,idEntry.get(),nameEntry.get(),surnameEntry.get(),loginEntry.get(),passwordEntry.get()))
	infoLabelInsert.place(x =10 , y =100)
	infoId.place(x = 244,y = 130)
	idEntry.place(x = 190, y = 150)
	infoName.place(x = 231,y = 180)
	nameEntry.place(x = 190,y = 200)
	infoSurname.place(x = 222, y = 230)
	surnameEntry.place(x = 190,y = 250)
	infoLogin.place(x = 234,y = 280)
	loginEntry.place(x = 190, y = 300)
	infoPassword.place(x = 222,y = 330)
	passwordEntry.place(x = 190,y = 350)
	insertB.place(x = 230,y = 375)

def userInterface(myUser):
	global introLabel,viewPeopleButton
	if(type(auth_l) != int):
		auth_l.destroy()
	if(type(auth_p) != int):
		auth_p.destroy()
	if(type(ent_l) != int):
		ent_l.destroy()
	if(type(ent_p) != int):
		ent_p.destroy()
	if(type(ent_b) != int):
		ent_b.destroy()
	introLabel = Label(window,text = 'Good Afternoon {}! Here is the list of possible options:'.format(myUser.getName()),font = ("Arial",12))
	viewPeopleButton = Button(window,text = 'View table', width=50,bg = "#f7cad0",fg='#000000',font = ("Arial",12), command = lambda:viewTable(myUser))
	introLabel.place(x =30 , y=150 )
	viewPeopleButton.place(x = 19,y = 180)
	#introLabel.place(x=50,y=0)
	#viewPeopleButton.place(x=100,y=30)

def finalUpdate(myAdmin,login,newName,newSurname):
	if(university.findUser(login) == None):
		mesBox.showerror('Error!','There is no such user!')
	else:
		myUser = university.findUser(login)
		myAdmin.updateUser(myUser.getNumberId(),newName,newSurname,login)
		loginOfNeededUser.destroy()
		loOfUser.destroy()
		userEntry.destroy()
		newNameLabel.destroy()
		newNameEntry.destroy()
		newSurnameLabel.destroy()
		newSurnameEntry.destroy()
		finalButtonUpdate.destroy()
		adminInterface(myAdmin)

def updateUser(myAdmin):
	global loginOfNeededUser,loOfUser,userEntry,newNameLabel,newNameEntry,newSurnameLabel,newSurnameEntry,finalButtonUpdate
	introLabel.destroy()
	viewPeopleButton.destroy()
	deleteButton.destroy()
	insertButton.destroy()
	updateButton.destroy()
	grateFullOutput.destroy()
	outputLabel.destroy()

	loginOfNeededUser = Label(window, text = 'Please, type the login of the User that you want to change and fill new Data below:',font = ("Arial",10))
	loOfUser = Label(window,text= 'User login',font = ("Arial",10))
	userEntry = Entry(window)
	newNameLabel = Label(window, text = 'New Name',font = ("Arial",10))
	newNameEntry = Entry(window)
	newSurnameLabel = Label(window,text = 'New Surname',font = ("Arial",10))
	newSurnameEntry = Entry(window)
	finalButtonUpdate = Button(window,text= 'Update User',bg = "#fcf6bd",fg='#000000',font = ("Arial",10),command = lambda:finalUpdate(myAdmin,userEntry.get(),newNameEntry.get(),newSurnameEntry.get()))
	loginOfNeededUser.place(x = 9, y = 150 )
	loOfUser.place(x = 215, y = 180 )
	userEntry.place(x = 184, y =200 )
	newNameLabel.place(x = 213 , y = 230)
	newNameEntry.place(x = 183, y =250 )
	newSurnameLabel.place(x = 205, y = 280 )
	newSurnameEntry.place(x = 183 , y =300 )
	finalButtonUpdate.place(x =208 , y = 330)


def adminInterface(myAdmin):
	userInterface(myAdmin)
	global deleteButton, insertButton, updateButton
	deleteButton = Button(window,text = 'Kill User(Delete)',bg = "#ef476f",fg='#000000',font = ("Arial",12), command = lambda:deleteUser(myAdmin))
	insertButton = Button(window,text = 'Add User(Insert)',bg = "#06d6a0",fg='#000000',font = ("Arial",12), command = lambda:insertUser(myAdmin))
	updateButton = Button(window,text = 'Refresh User\'s Data(Update)',bg = "#ffd166",fg='#000000',font = ("Arial",12),command = lambda:updateUser(myAdmin))
	deleteButton.place(x=10,y=225)
	insertButton.place(x=140,y=225)
	updateButton.place(x=270,y=225)

def authorization():
	global auth_l,auth_p,ent_l,ent_p,ent_b
	l1.destroy()
	b1.destroy()
	b2.destroy()
	auth_l = Label(window, text='login',font = ("Arial",12))
	auth_p = Label(window, text='password',font = ("Arial",12))
	ent_l = Entry(window)
	ent_p = Entry(window)
	ent_b = Button(window, text='Enter',font = ("Arial",12), command=enterSystem)
	auth_l.place(x=200,y=120)
	auth_p.place(x=200,y=180)
	ent_l.place(x=200,y=150)
	ent_p.place(x=200,y=210)
	ent_b.place(x=200,y=240)

def registerNewGuestFinally(regId,regName,regSurname,regLogin,regPassword):
	temirAdmin = university.allTheUsers[0]
	createdUser = User(regId,regName,regSurname,regLogin,regPassword)
	temirAdmin.insertUser(regId,regName,regSurname,regLogin,regPassword)
	return createdUser


def checkDataOfUserBeforeRegistration(regId,regName,regSurname,regLogin,regPassword):
	if(university.findUser(regLogin)!=None):
		mesBox.showerror('Error!','This User has been already existing!')
	else:
		if(university.checkPassword(regPassword) == False):
			mesBox.showerror('Error!','Your Password does not correspond to the conditions!')
		else:
			myUser = registerNewGuestFinally(regId,regName,regSurname,regLogin,regPassword)
			regInformation.destroy()
			regIdLabel.destroy()
			regIdEntry.destroy()
			regNameLabel.destroy()
			regNameEntry.destroy()
			regSurnameLabel.destroy()
			regSurnameEntry.destroy()
			regLoginLabel.destroy()
			regLoginEntry.destroy()
			regPaswwordLabel.destroy()
			regPasswordEntry.destroy()
			regButton.destroy()
			userInterface(myUser)






def registerUser():
	window.configure(bg = '#f2cc8f')
	global regInformation,regIdLabel,regIdEntry,regNameLabel,regNameEntry,regSurnameLabel,regSurnameEntry,regLoginLabel,regLoginEntry,regPaswwordLabel,regPasswordEntry,regButton
	l1.destroy()
	b1.destroy()
	b2.destroy()
	regInformation = Label(window,text = 'Hello! You need to fill in all the information which is listed below:',bg = "#faedcd",fg='#000000',font = ("Arial",13))
	regIdLabel = Label(window,text = 'ID of the User:',font = ("Arial",13))
	regIdEntry = Entry(window)
	regNameLabel = Label(window, text = 'Name of the User:',font = ("Arial",13))
	regNameEntry = Entry(window)
	regSurnameLabel = Label(window, text = 'Surname of the User:',font = ("Arial",13))
	regSurnameEntry = Entry(window)
	regLoginLabel = Label(window, text = 'Login of the User:',font = ("Arial",13))
	regLoginEntry = Entry(window)
	regPaswwordLabel = Label(window, text = 'Password of the User:',font = ("Arial",13))
	regPasswordEntry = Entry(window)
	regButton = Button(window,text = 'Register User',font = ("Arial",13),command = lambda:checkDataOfUserBeforeRegistration(regIdEntry.get(),regNameEntry.get(),regSurnameEntry.get(),regLoginEntry.get(),regPasswordEntry.get()))

	regInformation.place(x = 15,y = 50)
	regIdLabel.place(x = 180,y = 80)
	regIdEntry.place(x = 175,y = 110)
	regNameLabel.place(x = 167,y = 140)
	regNameEntry.place(x = 175,y = 170)
	regSurnameLabel.place(x = 155, y = 200)
	regSurnameEntry.place(x = 174,y = 230)
	regLoginLabel.place(x = 165,y = 260)
	regLoginEntry.place(x = 174,y = 290)
	regPaswwordLabel.place(x = 150,y = 320)
	regPasswordEntry.place(x = 173,y = 350)
	regButton.place(x = 180,y = 380)




def beginIntroduction():
	global l1,b1,b2
	l1 = Label(window, text='Hello!!! Welcome to System! Please, choose one of the options',bg = "#ea9999",fg='#000000',font = ("Arial",12))
	b1 = Button(window, text='Authorization',width=10,bg = "#ffd966",fg='#000000',font = ("Arial",15), command=authorization)
	b2 = Button(window, text='Register',width=10,bg = "#ffd966",fg='#000000',font = ("Arial",15),command = registerUser)
	l1.place(x=27,y=100)
	b1.place(x=100,y=250)
	b2.place(x=270,y=250)

university = universitySystem()

window = Tk()
window.geometry('500x500')
window.configure(bg = '#856ff8')
beginIntroduction()
window.mainloop()
#university.createUser(university,'2','Temirlan','Serikov','te_serikov','Timka2019!')
#for user in university.allTheUsers:
#	if(type(user) == Admin):
#		print('The admin is',user.getName(),type(user))
#	else:
#		print('The user is',user.getName(),type(user))

#cursor.execute('''CREATE TABLE users(
#	numberId varchar(5),
#	userName varchar(20),
#	userSurname varchar(20),
#	userType varchar(10)
#			);''')
#cursor.execute("insert into users values('1','Temirbolat','Maratuly','admin');")

#conn.commit()

