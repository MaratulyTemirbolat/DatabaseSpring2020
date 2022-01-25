from tkinter import *
from datetime import datetime
from tkinter.ttk import Combobox
from temirParameters import *
import pyodbc
from threading import Timer
import time
from tkinter import messagebox as mesBox
subWindowOpened = False
conn = pyodbc.connect('Driver={SQL Server};'
					   'Server=DESKTOP-9VV7AM5;'
					   'Database=hotelFinalAgain_ag;'
					   'Trusted_Connection=yes;')
cursor = conn.cursor()
cursorTwo = conn.cursor()
cursorThree = conn.cursor()


def defineInput(variable):
	if(variable == '' or variable == ' '):
		return 'NULL'
	sizeWord = len(variable)
	cnt = 0
	for letter in variable:
		if(ord(letter)>=48 and ord(letter)<=57):
			cnt+=1
	if(cnt == sizeWord):
		return variable
	else:
		newVariable = '\'' + variable + '\''
		return newVariable

def saveReservations():
	cursor.execute("""select * from RESERVATION res join Guest_Reservation g_r on res.reservation_id = g_r.reservation_id""")
	var_fix = []
	for row in cursor:
		var_fix.append(list(map(str,list(row))))
	f = open("pythonReservations.txt","w")
	word = ''
	for k in var_fix:
		for j in k:
			j = j.replace('  ','')
		word +=str(k)
		word +='\n'

	f.write(word)
	f.close()

def saveRoomAudit():
	cursor.execute("""select * from room_audit""")
	var_fix = []
	for row in cursor:
		var_fix.append(list(map(str,list(row))))
	f = open("PythonRoomAudit.txt","w")
	word = ''
	for k in var_fix:
		for j in k:
			j = j.replace('  ','')
		word += str(k)
		word += '\n'
	f.write(word)
	f.close()


def isOkayData(g_id,g_name,g_surname,g_address,g_db,g_fam_stat,g_phone,g_email,g_day_arr,g_day_dep,prep,pet_number,child_number,g_gender):
	if (len(g_id) == 0 or len(g_name) == 0 or len(g_surname) == 0 or len(g_address) == 0 or len(g_db) == 0 or len(g_fam_stat) == 0 or len(g_phone) == 0 or  len(g_email) == 0 or len(g_day_arr) == 0 or len(g_day_dep) == 0 or len(prep) == 0 or len(pet_number) ==0 or len(child_number) == 0 or len(g_gender) == 0):
		return False
	return True

def make_reservation(g_id,g_name,g_surname,g_address,g_db,g_fam_stat,g_phone,g_email,g_des_type,g_des_floor,g_day_arr,g_day_dep,prep,pet_number,child_number,g_gender):
	g_id = defineInput(g_id)
	g_name = defineInput(g_name)
	g_surname = defineInput(g_surname)
	g_address = defineInput(g_address)
	g_db = defineInput(g_db)
	g_fam_stat = defineInput(g_fam_stat)
	g_phone = defineInput(g_phone)
	g_email = defineInput(g_email)
	g_day_arr = defineInput(g_day_arr)
	g_day_dep = defineInput(g_day_dep)
	prep = defineInput(prep)
	pet_number = defineInput(pet_number)
	child_number = defineInput(child_number)
	g_gender = defineInput(g_gender)
	proc_result = ''
	noProb = False
	if(isOkayData(g_id,g_name,g_surname,g_address,g_db,g_fam_stat,g_phone,g_email,g_day_arr,g_day_dep,prep,pet_number,child_number,g_gender) == False):
		mesBox.showerror('Error','You did not fill some of the Info!')
	else:
		if(g_des_type != 'NULL' ):
			if(g_des_type == ''):
				g_des_type = 'NULL'
			else:
				g_des_type = '\'' + g_des_type + '\''
		if(g_des_floor != 'NULL'):
			if(g_des_floor  == ''):
				g_des_floor = 'NULL'
			else:
				g_des_floor = '\'' + g_des_floor + '\'' ## РАЗОБРАТЬСЯ С ИНПУТОМ!  ПРОВЕРКА ГОДА 
		cursorTwo.execute("""exec registerNewGuest @guestId = {} , @guestName = {} , @guestSurname = {},@guestAddress = {} ,@guestDateOfBirth = {},@guestFamilyStatus = {}, @guestPhoneNumber = {}, @guestEmail = {}, @desiredRoomType = {},  @desiredFloor = {}, @dayOfArrival= {}, @dayOfDeparture = {}, @prepayment = {}, @petNumber = {}, @childNumber = {}, @gender = {}""".format(g_id,g_name,g_surname,g_address,g_db,g_fam_stat,g_phone,g_email,g_des_type,g_des_floor,g_day_arr,g_day_dep,prep,pet_number,child_number,g_gender))
		
		for l in cursorTwo:
			l = list(l)
			result = str(l[0])
			if('Sorry' in result):
				noProb = True
				mesBox.showerror('Error',result)
			print(result)
		conn.commit()
		if(noProb == False):
			subMain.destroy()
			showAllReservations()
			saveReservations()
			saveRoomAudit() # добавить

def getRoomAuditDescription():
	subMain = Toplevel(main)
	myList = cursor.execute("""select room_id, room_status, room_description,reservation_id,guest_id from room_audit;""")

	e=Label(subMain,width=15,text='room_id',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=0)
	e=Label(subMain,width=15,text='room_status',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=1)
	e=Label(subMain,width=15,text='room_description',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=2)
	e=Label(subMain,width=15,text='reservation_id',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=3)
	e=Label(subMain,width=15,text='guest_id',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=4)

	subWindowOpened = True
	i=1
	for room in myList:
		for j in range(5):
			e = Entry(subMain, width=18, fg='blue') 
			e.grid(row=i, column=j) 
			e.insert(END, room[j])
		i=i+1
	conn.commit()

def showAllReservations():
	#global allReservations_label
	global subMain
	subMain = Toplevel(main)
	count = 0
	cursor.execute("select count(*) from RESERVATION res join GUEST_RESERVATION g_r on res.reservation_id = g_r.reservation_id;")
	for row in cursor:
		count = row[0]
	listN = cursor.execute("""select res.reservation_id,res.arrival_date,res.departure_date,res.reservation_room_id,
											res.reservation_date,res.prepayment,res.reservation_status,g_r.guest_id 
											from RESERVATION res join GUEST_RESERVATION g_r 
											on res.reservation_id = g_r.reservation_id;""")
	e=Label(subMain,width=15,text='reservation_id',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=0)
	e=Label(subMain,width=15,text='arrival_date',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=1)
	e=Label(subMain,width=15,text='departure_date',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=2)
	e=Label(subMain,width=15,text='room_id',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=3)
	e=Label(subMain,width=15,text='reservation_date',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=4)
	e=Label(subMain,width=15,text='prepayment',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=5)
	e=Label(subMain,width=15,text='reservation_status',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=6)
	e=Label(subMain,width=15,text='guest_id',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=7)
	subWindowOpened = True
	i=1
	for room in listN:
		for j in range(8):
			e = Entry(subMain, width=18, fg='blue') 
			e.grid(row=i, column=j) 
			e.insert(END, room[j])
		i=i+1
	conn.commit()
	
	#output = ''
	
	#for row in cursor:
	#	output+=str(row) + '\n'
	#output = output.replace(',',' , ')
	#allReservations_label = Label(main,text = output)
	#allReservations_label.place(x = 800,y = 200)
	#conn.commit()



def do_room_reservation():
	global intoLabel_reservation, reservation_description, guest_id_label,guest_id_entry, guest_name_label, guest_name_entry, guest_surname_label, guest_surname_entry,guest_address_label, guest_address_entry, guest_birthday_label, guest_birthday_entry
	global guest_family_status_label, guest_family_status_box, guest_mob_number_label, guest_mob_number_entry, guest_email_label, guest_email_entry 
	global guest_desired_type_room_label, guest_desired_type_room_box, guest_desired_floor_room_label, guest_desired_floor_room_box, guest_arrval_date_label, guest_arrval_date_entry, guest_departure_date_label, guest_departure_date_entry, guest_prep_label, guest_prep_entry, guest_pets_number_label, guest_pets_number_entry
	global guest_children_number_label, guest_children_number_entry, guest_gender_label, guest_gender_entry, book_buttom, currReservations_Button, currDay_label
	intoLabel_reservation = Label(main,text = 'You have selected the Option : ROOM BOOKING')
	descr = '''This procedure is responsible to make a reservation for a guest. 
	If you want to create a reservation you need to fill the following guest\'s data such as:
	Document ID, Name, Surname, Address, BirthDay, family status, mobile number, e-mail, type of the wished room,desired room floor, day of the Arrival, Departure Date, Prepayment, your gender, amount of animals and children number.
	After inputting all the data the free rooms are checked corresponding all the guest\'s wishes. 
	If all the information is okay and there is a free room then the reservation would be created and room becomes free.'''
	reservation_description = Label(main,text = descr)
	guest_id_label = Label(main, text = 'Please, type the Guest\'s ID: ')
	guest_id_entry = Entry(main)
	guest_name_label = Label(main,text = 'Please,type the Guest\'s Name: ')
	guest_name_entry = Entry(main)
	guest_surname_label = Label(main,text = 'Please, type the Guest\'s Surname: ')
	guest_surname_entry = Entry(main)
	guest_address_label = Label(main, text = 'Please, type the Guest\'s Address: ')
	guest_address_entry = Entry(main)
	guest_birthday_label = Label(main, text = 'Please, type the Guest\'s BirthDay: ')
	guest_birthday_entry = Entry(main)
	guest_family_status_label = Label(main,text = 'Please, choose the Guest\'s Family Status: ')
	guest_family_status_box = Combobox(main)
	guest_family_status_box['values'] = ('','single','married','divorced')
	guest_family_status_box.current(0)
	guest_mob_number_label  = Label(main,text = 'Please, type the Guest\'s Mobile number: ')
	guest_mob_number_entry = Entry(main) #???
	guest_email_label = Label(main, text = 'Please, type the Guest\'s e-mail: ')
	guest_email_entry = Entry(main)
	guest_desired_type_room_label = Label(main,text = 'Please, click on the desired Room Type: ') # ОТСЛЕЖИВАТЬ
	guest_desired_type_room_box = Combobox(main)
	guest_desired_type_room_box['values'] = ('','single', 'double', 'family', 'president')
	guest_desired_type_room_box.current(0) 
	guest_desired_floor_room_label = Label(main,text = 'Please, click on the desired Room Floor Location: ') 
	guest_desired_floor_room_box = Combobox(main) 
	guest_desired_floor_room_box['values'] = ('','2', '3', '4', '5')
	guest_desired_floor_room_box.current(0)
	guest_arrval_date_label = Label(main,text = 'Please, type the Guest\'s Arrival Date: ')
	guest_arrval_date_entry = Entry(main)
	guest_departure_date_label = Label(main, text = 'Please, type the Guest\'s Departure Date: ')
	guest_departure_date_entry = Entry(main)
	guest_prep_label = Label(main,text = 'Please, type the Guest\'s Prepayment: ')
	guest_prep_entry = Entry(main)
	guest_pets_number_label = Label(main, text = 'Please, type the Guest\'s Pet Number: ')
	guest_pets_number_entry = Spinbox(main, from_ = 0, to = 10,width = 5)
	guest_children_number_label = Label(main,text = 'Please, type the Guest\'s children Number: ')
	guest_children_number_entry = Spinbox(main, from_ = 0, to = 10,width = 5)
	guest_gender_label = Label(main, text = 'Please, type the Guest\'s gender: ')
	guest_gender_entry = Combobox(main)
	guest_gender_entry['values'] = ('Male','Female')
	guest_gender_entry.current(0)
	book_buttom = Button(main,text = 'RESERVE',command = lambda:make_reservation(guest_id_entry.get(),guest_name_entry.get(),guest_surname_entry.get(),guest_address_entry.get(),guest_birthday_entry.get(),guest_family_status_box.get(),guest_mob_number_entry.get(),guest_email_entry.get(),guest_desired_type_room_box.get(),guest_desired_floor_room_box.get(),guest_arrval_date_entry.get(),guest_departure_date_entry.get(),guest_prep_entry.get(),guest_pets_number_entry.get(),guest_children_number_entry.get(),guest_gender_entry.get()))
																								
	currReservations_Button = Button(main,text = 'Show Reservations',command = showAllReservations)

	today = datetime.date(datetime.now())

	intoLabel_reservation.pack()
	reservation_description.pack()
	guest_id_label.pack()
	guest_id_entry.pack()
	guest_name_label.pack()
	guest_name_entry.pack()
	guest_surname_label.pack()
	guest_surname_entry.pack()
	guest_address_label.pack()
	guest_address_entry.pack()
	guest_birthday_label.pack()
	guest_birthday_entry.pack()
	guest_family_status_label.pack()
	guest_family_status_box.pack()
	guest_mob_number_label.pack()
	guest_mob_number_entry.pack()
	guest_email_label.pack()
	guest_email_entry.pack()
	guest_desired_type_room_label.pack()
	guest_desired_type_room_box.pack()
	guest_desired_floor_room_label.pack()
	guest_desired_floor_room_box.pack()
	guest_arrval_date_label.pack()
	guest_arrval_date_entry.pack()
	guest_departure_date_label.pack()
	guest_departure_date_entry.pack()
	guest_prep_label.pack()
	guest_prep_entry.pack()
	guest_pets_number_label.pack()
	guest_pets_number_entry.pack()
	guest_children_number_label.pack()
	guest_children_number_entry.pack()
	guest_gender_label.pack()
	guest_gender_entry.pack()
	book_buttom.pack()
	currReservations_Button.pack()

	sentence = 'Today\'s Date is : ' + str(today)
	currDay_label = Label(main,text = sentence)
	currDay_label.pack()

def get_guest_reservations(guest_id):
	guest_id = defineInput(guest_id)
	
	subMainTwo = Toplevel(main)

	listN = cursorTwo.execute("""select res.reservation_id,res.arrival_date,res.departure_date,res.reservation_room_id,res.reservation_date,
	res.prepayment,res.reservation_status,g_r.guest_id from RESERVATION res join GUEST_RESERVATION g_r on res.reservation_id = g_r.reservation_id where g_r.guest_id = {};""".format(guest_id))

	e=Label(subMainTwo,width=15,text='reservation_id',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=0)
	e=Label(subMainTwo,width=15,text='arrival_date',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=1)
	e=Label(subMainTwo,width=15,text='departure_date',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=2)
	e=Label(subMainTwo,width=15,text='room_id',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=3)
	e=Label(subMainTwo,width=15,text='reservation_date',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=4)
	e=Label(subMainTwo,width=15,text='prepayment',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=5)
	e=Label(subMainTwo,width=15,text='reservation_status',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=6)
	e=Label(subMainTwo,width=15,text='guest_id',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=7)
	subWindowOpened = True
	i=1
	for room in listN:
		for j in range(8):
			e = Entry(subMainTwo, width=18, fg='blue') 
			e.grid(row=i, column=j) 
			e.insert(END, room[j])
		i=i+1
	conn.commit()

	#output = ''
	#for row in cursorTwo:
	#	output+=str(row) + '\n'
	#output = output.replace(',',' , ')
	#allReservations_label = Label(main,text = output)
	#allReservations_label.place(x = 800,y = 200)
	#conn.commit()

def make_cancelling(guest_id,res_arriv_day,res_dep_day):
	guest_id = defineInput(guest_id)
	res_arriv_day = defineInput(res_arriv_day)
	res_dep_day = defineInput(res_dep_day)
	proc_result = ''
	noProb = False
	cursor.execute("""exec spCancelBooking @guestId = {}, @arrivalGuestDate = {} , @departureGuestDate = {} ;""".format(guest_id,res_arriv_day,res_dep_day))
	for row in cursor:
		row = list(row)
		result = str(row[0])
		if('Sorry' in result):
			noProb = True
			mesBox.showerror('Error',result)
		print(row)
	cursor.commit()
	if(noProb == False):
		getRoomAuditDescription()


def cancel_reservation():
	into_label_cancel = Label(main,text = 'You have selected the Option  :  ROOM CANCEL')
	can_descr = '''This procedure is responsible to cancel Guest\'s ACTIVE reservation in ADVANCE.
	If you want to CANCEL the reservation make sure that the remained time before entrance is more than at least 24 hours, otherwise it is impossible.
	If everything is Okay then you need to fill Guest\'s ID and the ARRIVAL date of his ACTIVE future Reservation as well as DEPARTURE DATE.
	Finally, press the button cancel. Enjoy :) '''
	cancel_description = Label(main,text = can_descr)
	guest_id_lab = Label(main, text = 'Please, type the Guest\'s ID: ')
	guest_id_ent = Entry(main)
	guest_id_but = Button(main,text = 'See Reservations',command = lambda:get_guest_reservations(guest_id_ent.get()))
	guest_arrival_d_lab = Label(main, text = 'Please, type the Reservation\'s ARRIVAL DATE: ')
	guest_arrival_d_ent = Entry(main)
	guest_dep_d_lab = Label(main, text = 'Please, type the Reservation\'s DEPARTURE DATE: ')
	guest_dep_d_e = Entry(main)
	can_res_but = Button(main,text = 'CANCEL RESERVATION', command = lambda:make_cancelling(guest_id_ent.get(),guest_arrival_d_ent.get(),guest_dep_d_e.get()))

	today = datetime.now()
	sentence = 'Today\'s day is ' + str(today)
	tod_da_lab = Label(main,text = sentence)

	into_label_cancel.pack()
	cancel_description.pack()
	guest_id_lab.pack()
	guest_id_ent.pack()
	guest_id_but.pack()
	guest_arrival_d_lab.pack()
	guest_arrival_d_ent.pack()
	guest_dep_d_lab.pack()
	guest_dep_d_e.pack()
	can_res_but.pack()
	tod_da_lab.pack()

def join_guest(owner_id, j_guest_id, j_guest_name,j_guest_surname,j_guest_addr, j_guest_birthday, j_guest_fam_stat,j_guest_phone, j_guest_email,own_day_arrival,numb_pet,child_numb,j_g_gender):
	owner_id = defineInput(owner_id)
	j_guest_id = defineInput(j_guest_id)
	j_guest_name = defineInput(j_guest_name)
	j_guest_surname = defineInput(j_guest_surname)
	j_guest_addr = defineInput(j_guest_addr)
	j_guest_birthday = defineInput(j_guest_birthday)
	j_guest_fam_stat = defineInput(j_guest_fam_stat)
	j_guest_phone = defineInput(j_guest_phone)
	j_guest_email = defineInput(j_guest_email)
	own_day_arrival = defineInput(own_day_arrival)
	numb_pet = defineInput(numb_pet)
	child_numb = defineInput(child_numb)
	j_g_gender = defineInput(j_g_gender)
	proc_result = ''
	cursorTwo.execute("""exec joinCurrentGuestRoom @guestFindId = {},@guestId = {},@guestName = {},@guestSurname = {}, 
	@guestAddress= {},@guestDateOfBirth = {},@guestFamilyStatus = {},
	@guestPhoneNumber= {},@guestEmail = {}, @dayOfArrival = {}, @petNumber = {},
	@childNumber = {}, @gender= {};""".format(owner_id,j_guest_id,j_guest_name,j_guest_surname,j_guest_addr,j_guest_birthday,j_guest_fam_stat,j_guest_phone,j_guest_email,own_day_arrival,numb_pet,child_numb,j_g_gender))
	estProblem = False
	for l in cursorTwo:
		l = list(l)
		result = str(l[0])
		if('Sorry' in result):
			estProblem = True
			mesBox.showerror('Error',result)
		print(result)

	conn.commit()
	if(estProblem == False):
		mesBox.showerror('Successfully','You are Successfully Joined! ')


def join_procedure():
	intro_join_label = Label(main,text = 'You have selected the Option  :  JOIN RESERVATION')
	proc_descr = '''This procedure is responsible for joining the ACTIVE EXISCTED Reservation.
	If you want to JOIN the reservation successfully make sure that there is an owner having ACTIVE Reservation.
	Also, be confident that the capacity of this room is enough to live there.
	You need to fill the Owner\'s ID to see all his ACTIVE RESERVATIONS.
	You have to fill joined Guest personal INFO in order to add him(her) to database'''
	join_descr = Label(main,text = proc_descr)

	owner_id_lab = Label(main, text = 'Please, type the OWNER\'S ID:')
	owner_id_ent = Entry(main)
	owner_res_button = Button(main, text = 'SEE RESERVATION', command = lambda:get_guest_reservations(owner_id_ent.get()))
	guest_id_labe = Label(main,text = 'Please, type the Guest\'s ID:')
	guest_id_ent = Entry(main)
	guest_name_labe = Label(main, text = 'Please, type the Guest\'s Name:')
	guest_name_ent = Entry(main)
	guest_surname_lab = Label(main, text = 'Please, type the Guest\'s Surname:')
	guest_surname_ent = Entry(main)
	guest_addr_lab = Label(main, text = 'Please, type the Guest\'s Address:')
	guest_addr_ent = Entry(main)
	guest_birth_lab = Label(main, text = 'Please, type the Guest\'s BirthDay in format "yyyy-mm-dd" :')
	guest_birth_ent = Entry(main)
	guest_fam_stat_lab = Label(main, text = 'Please, type the Guest\'s Family Status:')
	guest_fam_stat_ent = Combobox(main)
	guest_fam_stat_ent['values'] = ('','single','married','divorced')
	guest_fam_stat_ent.current(0)
	guest_mob_numb_lab = Label(main, text = 'Please, type the Guest\'s Mobile number:')
	guest_mob_numb_ent = Entry(main)
	guest_email_lab = Label(main, text = 'Please, type the Guest\'s e-mail:')
	guest_email_ent = Entry(main)
	owner_arriv_date_lab = Label(main, text = 'Please, type the Owner\'s Arrival Date in Reservation: ')
	owner_arriv_date_ent = Entry(main)
	guest_gender_lab =  Label(main, text = 'Please, type the Guest\'s Gender:')
	guest_gender_ent = Combobox(main)
	guest_gender_ent['values'] = ('Male','Female')
	guest_gender_ent.current(0)
	guest_pets_numb_lab = Label(main, text = 'Please, type the number of pets with you: ')
	guest_pets_numb_ent = Spinbox(main, from_ = 0, to = 10,width = 5)
	guest_childr_numb_lab = Label(main, text = 'Please, type the number of children with your: ')
	guest_childr_numb_entr = Spinbox(main, from_ = 0, to = 10, width = 5)
	join_guest_button = Button(main, text = 'JOIN GUEST', command = lambda:join_guest(owner_id_ent.get(),guest_id_ent.get(),guest_name_ent.get(),guest_surname_ent.get(),guest_addr_ent.get(),guest_birth_ent.get(),guest_fam_stat_ent.get(),guest_mob_numb_ent.get(),guest_email_ent.get(),owner_arriv_date_ent.get(),guest_pets_numb_ent.get(),guest_childr_numb_entr.get(),guest_gender_ent.get()))

	intro_join_label.pack()
	join_descr.pack()
	owner_id_lab.pack()
	owner_id_ent.pack()
	owner_res_button.pack()
	guest_id_labe.pack()
	guest_id_ent.pack()
	guest_name_labe.pack()
	guest_name_ent.pack()
	guest_surname_lab.pack()
	guest_surname_ent.pack()
	guest_addr_lab.pack()
	guest_addr_ent.pack()
	guest_birth_lab.pack()
	guest_birth_ent.pack()
	guest_fam_stat_lab.pack()
	guest_fam_stat_ent.pack()
	guest_mob_numb_lab.pack()
	guest_mob_numb_ent.pack()
	guest_email_lab.pack()
	guest_email_ent.pack()
	owner_arriv_date_lab.pack()
	owner_arriv_date_ent.pack()
	guest_gender_lab.pack()
	guest_gender_ent.pack()
	guest_pets_numb_lab.pack()
	guest_pets_numb_ent.pack()
	guest_childr_numb_lab.pack()
	guest_childr_numb_entr.pack()
	join_guest_button.pack()

	today = datetime.now()
	sentence = 'Today\'s day is ' + str(today)
	tod_da_lab = Label(main,text = sentence)
	tod_da_lab.pack()

def getRoomAuditEvictedGuest(guest_id):
	subMainTwo = Toplevel(main)

	listN = cursorTwo.execute("""select room_id, room_status, room_description,reservation_id,guest_id from room_audit where guest_id = {} and room_date_beginning<=GetDate() and room_date_end>=GetDate();""".format(guest_id))

	e=Label(subMainTwo,width=20,text='room_id',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=0)
	e=Label(subMainTwo,width=20,text='room_status',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=1)
	e=Label(subMainTwo,width=20,text='room_description',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=2)
	e=Label(subMainTwo,width=20,text='reservation_id',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=3)
	e=Label(subMainTwo,width=20,text='guest_id',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=4)
	subWindowOpened = True
	i=1
	for room in listN:
		for j in range(5):
			e = Entry(subMainTwo, width=24, fg='blue') 
			e.grid(row=i, column=j) 
			e.insert(END, room[j])
		i=i+1
	conn.commit()

def evict_guest(guest_id,payment_type):
	guest_id = defineInput(guest_id)
	payment_type = defineInput(payment_type) # PAYMENT_TYPE УКАЗАТЬ
	proc_result = ''
	evictProblem = False
	cursorTwo.execute("""exec spEvictGuest @guestId = {}, @payment_type = {};""".format(guest_id,payment_type))
	for l in cursorTwo:
		l = list(l)
		result = str(l[0])
		if('Sorry' in result):
			evictProblem = True
			mesBox.showerror('Error',result)
		print(result)
	conn.commit()
	if(evictProblem == False):
		getRoomAuditEvictedGuest(guest_id)
		mesBox.showerror('Successfully',result)




def dismiss_guest():
	into_label_dismiss_guest = Label(main, text = ' You have selected the Option : GUEST DISMISSING ')
	description_dismiss = '''This procedure is responsible for dismissing employees from the hotel by their wish.
	If you want to Dismiss Guest or the Guests from Hotel you just need to type his or her ID.
	The system will automatically determine who it was, find his or her CURRENT ACTIVE Reservation including the Accomodation.
	The Guest will automatically get the Final Total Inovoice for the whole period which was not paid.'''
	descr_proc = Label(main,text = description_dismiss)

	guest_id_label = Label(main,text = 'Please, type the Guest\'s ID: ')
	guest_id_entry = Entry(main)
	guest_payment_type_label = Label(main,text = 'Please, type the Guest\'s Payment Type: ')
	guest_payment_type_box = Entry(main)
	guest_see_reservations_button = Button(main, text = 'See Reservations', command = lambda:get_guest_reservations(guest_id_entry.get()))
	guest_button_dissmissing = Button(main,text = 'EVICT GUEST', command = lambda:evict_guest(guest_id_entry.get(),guest_payment_type_box.get()))

	into_label_dismiss_guest.pack()
	descr_proc.pack()
	guest_id_label.pack()
	guest_id_entry.pack()
	guest_payment_type_label.pack()
	guest_payment_type_box.pack()
	guest_see_reservations_button.pack()
	guest_button_dissmissing.pack()

	today = datetime.now()
	sentence = 'Today\'s day is ' + str(today)
	tod_da_lab = Label(main,text = sentence)
	tod_da_lab.pack()

def showEmployEeeFirm(empl_id):
	subMainTwo = Toplevel(main)

	listN = cursorTwo.execute("""select firm_staff_id, firm_id,firm_staff_name,firm_staff_surname,firm_staff_job_title,previous_job_title,job_experience,firm_staff_salary_per_hour from firm_staff where firm_staff_id = {};""".format(empl_id))

	e=Label(subMainTwo,width=18,text='Staff_id',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=0)
	e=Label(subMainTwo,width=18,text='Firm_id',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=1)
	e=Label(subMainTwo,width=18,text='Staff_name',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=2)
	e=Label(subMainTwo,width=18,text='Surname',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=3)
	e=Label(subMainTwo,width=18,text='curr_job',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=4)
	e=Label(subMainTwo,width=18,text='prev_job',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=5)
	e=Label(subMainTwo,width=18,text='job_experience',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=6)
	e=Label(subMainTwo,width=18,text='salary_per_hour',borderwidth=2, relief='ridge',anchor='w',bg='yellow')
	e.grid(row=0,column=7)
	subWindowOpened = True
	i=1
	for room in listN:
		for j in range(8):
			e = Entry(subMainTwo, width=21, fg='blue') 
			e.grid(row=i, column=j) 
			e.insert(END, room[j])
		i=i+1
	conn.commit()


def getEmployeesPlaces(emp_id):
	emp_id = defineInput(emp_id)
	outputOne = ''
	outputTwo = ''
	cursor.execute("""select * from firm_staff where firm_staff_id = {} ;""".format(emp_id))
	for row in cursor:
		outputOne += str(row) + '\n'
	cursor.execute("""select * from hotel_staff where hotel_staff_id = {} ;""".format(emp_id))
	for row in cursor:
		outputTwo += str(row) + '\n'

	outputOne = outputOne.replace(',',' , ')
	outputTwo = outputTwo.replace(',',' , ')

	allReservations_labelFirm = Label(main,text = outputOne)
	allReservations_labelHotel = Label(main, text = outputTwo)

	allReservations_labelFirm.place(x = 10,y = 250)
	allReservations_labelHotel.place(x = 10,y = 200)
	conn.commit()

def finally_dismiss_empl(emp_id,departm_id,reason):
	emp_id = defineInput(emp_id)
	departm_id = defineInput(departm_id)
	reason = defineInput(reason)
	proc_result = ''
	cursor.execute("""exec spDismissEmployee @employeeId = {}, @departmentId = {}, @reason = {};""".format(emp_id,departm_id,reason))
	for l in cursor:
		l = list(l)
		result = str(l[0])
		if('Sorry' in result):
			mesBox.showerror('Error',result)
		print(result)
	conn.commit()

def dismiss_employee():
	into_lavel_dis_emp = Label(main, text = 'You have selected the Option : EMPLOYEE DISMISSING')
	description_empl_dismis = '''This procedure is responsible for the dismissal of an employee who works either in the hotel or in the firm.
	In order to dismiss an employee, you need to fill in the information in the form of his ID, the department where he works (optional), as well as the reason for his dismissal. 
	If the department is not specified, then the person will be fired in all companies.'''
	descr_proc = Label(main, text = description_empl_dismis)

	emp_id_label = Label(main,text = 'Please, type the Employee ID: ')
	emp_id_ent = Entry(main)
	emp_department_id_label = Label(main,text = 'Please, type the Department where ID works(optional): ')
	emp_department_id_ent = Entry(main)
	emp_reason_label = Label(main, text = 'Please, type the reason why you dismiss this Employee: ')
	emp_reason_entry = Entry(main)
	emp_get_where_works_buttom = Button(main, text = 'Get where Works', command = lambda:getEmployeesPlaces(emp_id_ent.get()))
	emp_dism_button = Button(main, text = 'DISMISS EMPLOYEE', command = lambda:finally_dismiss_empl(emp_id_ent.get(),emp_department_id_ent.get(),emp_reason_entry.get()))

	into_lavel_dis_emp.pack()
	descr_proc.pack()
	emp_id_label.pack()
	emp_id_ent.pack()
	emp_department_id_label.pack()
	emp_department_id_ent.pack()
	emp_reason_label.pack()
	emp_reason_entry.pack()
	emp_get_where_works_buttom.pack()
	emp_dism_button.pack()

	today = datetime.now()
	sentence = 'Today\'s day is ' + str(today)
	tod_da_lab = Label(main,text = sentence)
	tod_da_lab.pack()

def menu_options(login):
	pass

def final_enter(login,password):
	login = defineInput(login)
	password = defineInput(password)
	proc_result = ''
	isProblem = False
	cursor.execute("""exec spEnterSystem @login = {}, @password = {};""".format(login,password))
	for l in cursor:
		l = list(l)
		result = str(l[0])
		if('Sorry' in result):
			mesBox.showerror('Error',result)
			isProblem = True
		print(result)
	if(isProblem == False):
		menu_options(login)
	conn.commit()




def enter_system():
	login_label = Label(main,text = 'Login')
	login_entry = Entry(main)
	password_label = Label(main, text = 'Password')
	password_entry = Entry(main)
	enter_buttom = Button(main, text = 'Enter System', command = lambda:final_enter(login_entry.get(),password_entry.get()))

	login_label.pack()
	login_entry.pack()
	password_label.pack()
	password_entry.pack()
	enter_buttom.pack()

# Убрал в RESERVATION identity и вставил свою register добавил Update room_audit
# Trigger добавил в insert res и guest Также создал переменную ГЕстАйди там
main = Tk()
#do_room_reservation()
#ancel_reservation()
#join_procedure()
dismiss_guest()
#dismiss_employee()
#enter_system()
main.mainloop()

