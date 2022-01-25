from threading import Timer


def syaHello(word):
	print(word,type(word))

t = Timer(5,syaHello,[5])
t.start()