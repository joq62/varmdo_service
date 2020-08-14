## set the paths for a default setup
all:
	rm -rf *_service include *~ */*~ */*/*~;
	rm -rf */*~ test_ebin/* test_src/*.beam test_src/*~;
	rm -rf */*.beam;
	rm -rf *.beam erl_crash.dump */erl_crash.dump */*/erl_crash.dump;
#	include
	git clone https://github.com/joq62/include.git;
	cp src/*.app ebin;
	erlc -I include -o ebin src/*.erl;
clean:
	rm -rf */*~ *.beam ebin/*.beam *~
test:
	rm -rf include *_service */*~ *.beam ebin/*.beam *~;
	rm -rf */*~ test_ebin/* test_src/*.beam test_src/*~;
#	include
	git clone https://github.com/joq62/include.git;
#	mail_service
	git clone https://github.com/joq62/mail_service.git;	
	cp mail_service/src/*.app mail_service/ebin;
	erlc -I include -o mail_service/ebin mail_service/src/*.erl;
	cp src/*.app ebin;
	erlc -I include -o  ebin src/*.erl;
	erlc -I include -o test_ebin test_src/*.erl;
	erl -pa */ebin -pa ebin -pa test_ebin -s test1 start -sname varmdo_service -setcookie abc

test2:
	rm -rf include *_service */*~ *.beam ebin/*.beam *~;
	rm -rf */*~ test_ebin/* test_src/*.beam test_src/*~;
#	include
	git clone https://github.com/joq62/include.git;
	cp src/*.app ebin;
	erlc -I include -o  ebin src/*.erl;
	erlc -I include -o test_ebin test_src/*.erl;
	erl -pa */ebin -pa ebin -pa test_ebin -s test2 start -sname varmdo_service -setcookie abc
