from tkinter import *
from datetime import date
import pyodbc 
from Parameters import *
from PIL import ImageTk, Image
import os
path = str(os.path.dirname(os.path.abspath(__file__)))
main = Tk()
main.geometry('1080x700')
main.configure(bg='#05081a')
main.title('Veyron Sky')
conn = pyodbc.connect('Driver={SQL Server};'
                       'Server=DESKTOP-9VV7AM5;'
                       'Database=hotel;'
                       'Trusted_Connection=yes;')
cursor = conn.cursor()

def progress():
	pass

def hover_admin(event):
	global adm_pic
	adm_pic = PhotoImage(file=path+'\\admin_hover.png')
	admin_button['image'] = adm_pic

def hoverl_admin(event):
	global adm_pic
	adm_pic = PhotoImage(file=path+'\\admin.png')
	admin_button['image'] = adm_pic 

def hover_guest(event):
	global gst_pic
	gst_pic = PhotoImage(file=path+'\\guest_hover.png')
	guest_button['image'] = gst_pic

def hoverl_guest(event):
	global gst_pic
	gst_pic = PhotoImage(file=path+'\\guest.png')
	guest_button['image'] = gst_pic

def hover_about(event):
	global ab_pic
	ab_pic = PhotoImage(file=path+'\\about_hover.png')
	ab_button['image'] = ab_pic

def hoverl_about(event):
	global ab_pic
	ab_pic = PhotoImage(file=path+'\\about.png')
	ab_button['image'] = ab_pic

def timer():
	global t
	if t>0:
		lbl.config(text=t)
		t = t-1
		lbl.after(1000,timer)
	elif t==0:
		h_name.pack_forget()
		gr1.pack_forget()
		gr2.pack_forget()
		lbl.pack_forget()
		build()

def send():
	global gr1,gr2, lbl
	feedback_entry.pack_forget()	
	f1.pack_forget()
	lbl = Label(main, text='')
	gr1 = Label(main, text='Your text has been sent') 
	gr2 = Label(main, text='Thank you :)')
	gr1.pack()
	gr2.pack()
	lbl.pack()
	timer()

def information():
	global text
	admin_button.place_forget()
	guest_button.place_forget()
	ab_button.place_forget()
	contacts.place_forget()
	text = Label(main, text='Information about hotel')
	text.pack()

def admin():
	global login,password,enter_button
	title.place_forget()
	contacts.place_forget()
	admin_button.place_forget()
	guest_button.place_forget()
	ab_button.place_forget()
	login = Entry(main)
	password = Entry(main)
	enter_button = Button(main, text='Enter', command=enter_adm)
	login.pack()
	password.pack()
	enter_button.pack()

def guest():
	global login,password,enter_button,comment
	title.place_forget()
	admin_button.place_forget()
	guest_button.place_forget()
	ab_button.place_forget()
	comment = Label(main, text='Share your feedback or suggestion')
	login = Entry(main)
	password = Entry(main)
	enter_button = Button(main, text='Enter', command=enter_gst)
	comment.pack()
	login.pack()
	password.pack()
	enter_button.pack()

def enter_adm():
	global f1,f2,f3,f4,f5,f6,f7,f8
	login.pack_forget()
	password.pack_forget()
	enter_button.pack_forget()
	f1 = Button(main, text='Reserve a room')
	f2 = Button(main, text='Cancel booking')
	f3 = Button(main, text='Rating')
	f4 = Button(main, text='Manage prices')
	f5 = Button(main, text='Hotel staff')
	f6 = Button(main, text='Account update')
	f7 = Button(main, text='Eviction of a guest')
	f8 = Button(main, text='Dismissal of an employee')
	f1.pack()
	f2.pack()
	f3.pack()
	f4.pack()
	f5.pack()
	f6.pack()
	f7.pack()
	f8.pack()

def enter_gst():
	global feedback_entry,f1
	comment.pack_forget()
	login.pack_forget()
	password.pack_forget()
	enter_button.pack_forget()
	feedback_entry = Entry(main, width=40)
	f1 = Button(main, text='Send', command=send)
	feedback_entry.pack()
	f1.pack()

def build():
	global title,h_name,h_name2,admin_button,guest_button,ab_button,contacts,adm_pic,gst_pic,ab_pic
	x = path+'\\welcome.png'
	img = Image.open(x)
	img = img.resize((600, 300), Image.ANTIALIAS)
	img = ImageTk.PhotoImage(img)
	title = Label(main, image=img, bg='#05081a')
	title.image = img
	title.place(x=250,y=-120)
	y = path+'\\contacts.png'
	img2 = Image.open(y)
	img2 = img2.resize((300, 150), Image.ANTIALIAS)
	img2 = ImageTk.PhotoImage(img2)
	contacts = Label(main, image=img2, bg='#05081a')
	contacts.image = img2
	contacts.place(x=10,y=85)
	z = path+'\\logo.png'
	img3 = Image.open(z)
	img3 = img3.resize((350, 200), Image.ANTIALIAS)
	img3 = ImageTk.PhotoImage(img3)
	h_name = Label(main, image=img3, bg='#05081a')
	h_name.image = img3
	h_name.place(x=370,y=70)
	v = path+'\\title.png'
	img4 = Image.open(v)
	img4 = img4.resize((400, 180), Image.ANTIALIAS)
	img4 = ImageTk.PhotoImage(img4)
	h_name2 = Label(main, image=img4, bg='#05081a')
	h_name2.image = img4
	h_name2.place(x=340,y=230)
	adm_pic = PhotoImage(file=path+'\\admin.png')
	admin_button = Button(main, bg='#05081a', image=adm_pic, borderwidth=0, command=admin)
	gst_pic = PhotoImage(file=path+'\\guest.png')
	guest_button = Button(main, bg='#05081a', image=gst_pic, borderwidth=0, command=guest)
	ab_pic = PhotoImage(file=path+'\\about.png')
	ab_button = Button(main, bg='#05081a', image=ab_pic, borderwidth=0, command=information)
	admin_button.bind('<Enter>',hover_admin)
	guest_button.bind('<Enter>',hover_guest)
	ab_button.bind('<Enter>',hover_about)
	admin_button.bind('<Leave>',hoverl_admin)
	guest_button.bind('<Leave>',hoverl_guest)
	ab_button.bind('<Leave>',hoverl_about)
	admin_button.place(x=80,y=420)
	guest_button.place(x=700,y=420)
	ab_button.place(x=400,y=570)

#Temirbolat
def do_room_reservation():
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
	guest_family_status_box = Entry(main)
	guest_mob_number_label  = Label(main,text = 'Please, type the Guest\'s Mobile number: ')
	guest_mob_number_entry = Entry(main) #???
	guest_email_label = Label(main, text = 'Please, type the Guest\'s e-mail: ')
	guest_email_entry = Entry(main)
	guest_desired_type_room_label = Label(main,text = 'Please, click on the desired Room Type: ') # ОТСЛЕЖИВАТЬ
	guest_desired_type_room_box = Entry(main) # ???
	guest_desired_floor_room_label = Label(main,text = 'Please, click on the desired Room Floor Location: ') # ОТСЛЕЖИВАТЬ
	guest_desired_floor_room_box = Entry(main) #???
	guest_arrval_date_label = Label(main,text = 'Please, type the Guest\'s Arrival Date: ')
	guest_arrval_date_entry = Entry(main)
	guest_departure_date_label = Label(main, text = 'Please, type the Guest\'s Departure Date: ')
	guest_departure_date_entry = Entry(main)
	guest_pets_number_label = Label(main, text = 'Please, type the Guest\'s Pet Number: ')
	guest_pets_number_entry = Entry(main)
	guest_children_number_label = Label(main,text = 'Please, type the Guest\'s children Number: ')
	guest_children_number_entry = Entry(main)

	today = date.today()

	todaysDate = today.strftime("%d/%m/%Y")
	todaysDate = (str(todaysDate)).replace('/','-')

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
	guest_pets_number_label.pack()
	guest_pets_number_entry.pack()
	guest_children_number_label.pack()
	guest_children_number_entry.pack()

	currentReservations = cursor.execute("""select res.reservation_id,res.arrival_date,res.departure_date,res.reservation_room_id,
res.reservation_date,res.prepayment,res.reservation_status,g_r.guest_id,
g_r.pet_number,g_r.child_number from RESERVATION res join GUEST_RESERVATION g_r 
on res.reservation_id = g_r.reservation_id;""")


build()
main.mainloop()