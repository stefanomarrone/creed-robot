;*****************************
; TESTING FUNCTIONS
;*****************************

.PROGRAM stub()
	.$msg = "<GET,C05,150.00,150.00,N01,0*>"
	CALL strlen($msg,.ll)
	.trail = .ll - 5
	.$payload = $MID($msg,5,.trail)
	CALL decode_get(.$payload,.xclo,.yclo,.last_action)
	PRINT "BUU"
	PRINT .xclo
	PRINT .yclo
	PRINT .last_action
	PRINT $closet
	PRINT $outcloset
.END


;*****************************
; OUTBOUND FUNCTIONS
;*****************************

.PROGRAM openoutrack()
	DRAW 400,0,0,0,0,0
	DRAW 0,0,100,0,0,0
	DRAW 200,0,0,0,0,0
	CALL center_out_scarico	
.END

.PROGRAM act_open()
	HOME 2
	SPEED 100
	CALL gotooutrack
	CALL openoutrack
	MVWAIT 1mm
.END

.PROGRAM closettodrop(.$o,.z,.y)
	.zDropUnit = -300
	.yDropUnit = 600
	.$col = $LEFT(.$o,1)
	CALL util_closet_convert(.$col,.y)
	.y = .y * .yDropUnit 
	.$row = $MID(.$o,3,1)
	.z = (VAL(.$row) - 1)
	.z = .z  * .zDropUnit
.END


.PROGRAM act_get(.xc,.yc,.la)
	.zdrop = 0
	.ydrop = 0
	.xdrop = 100
	.$code = $closet
	.$ocode = $outcloset
	CALL scarico_to_carico
	CALL dispatch_carico(.$code)
	CALL openrack
	PRINT "SCARICO - OPENRACK"
	CALL fromcloset(.xc,.yc)
	CALL closerack
	PRINT "SCARICO - CLOSERACK"
	CALL to_scarico_alto
	MVWAIT 1mm	
	CALL closettodrop(.$ocode,.zdrop,.ydrop)
	DRAW -.xdrop,.ydrop,.zdrop,0,0,0,100
	DRAW 0,0,-100,0,0,0,100
	MVWAIT 1mm	
	SIGNAL -1
	DRAW 0,0,100,0,0,0,100
	IF .la == 0 THEN 
		PRINT "ANCORA"
		DRAW .xdrop,-.ydrop,-.zdrop,0,0,0,100
		CALL to_carico_alto
	END
	IF .la == 1 THEN 
		PRINT "ULTIMO"
		DRAW .xdrop,0,0,0,0,0,100
		CALL close_out_closet(.$ocode)
		CALL center_scarico
		HOME 2
	END
.END

; aggiustare questa routine in futuro: inguardabile
.PROGRAM util_closet_convert(.$c,.yy)
	IF .$c == "M" THEN 
		.yy = 2
	END
	IF .$c == "N" THEN 
		.yy = 1
	END
	IF .$c == "O" THEN 
		.yy = 0
	END
	IF .$c == "P" THEN 
		.yy = -1
	END
	IF .$c == "Q" THEN 
		.yy = -2
	END
.END

.PROGRAM close_out_closet(.$code)
	IF .$code == "Q01" THEN 
		CALL closed_sca_q1
	END
	IF .$code == "Q02" THEN 
		CALL closed_sca_q2
	END
	IF .$code == "Q03" THEN 
		CALL closed_sca_q3
	END
	IF .$code == "Q04" THEN 
		CALL closed_sca_q4
	END
	IF .$code == "M01" THEN 
		CALL closed_sca_m1
	END
	IF .$code == "M02" THEN 
		CALL closed_sca_m2
	END
	IF .$code == "M03" THEN 
		CALL closed_sca_m3
	END
	IF .$code == "M04" THEN 
		CALL closed_sca_m4
	END
	IF .$code == "N01" THEN 
		CALL closed_sca_n1
	END
	IF .$code == "N02" THEN 
		CALL closed_sca_n2
	END
	IF .$code == "N03" THEN 
		CALL closed_sca_n3
	END
	IF .$code == "N04" THEN 
		CALL closed_sca_n4
	END
	IF .$code == "O01" THEN 
		CALL closed_sca_o1
	END
	IF .$code == "O02" THEN 
		CALL closed_sca_o2
	END
	IF .$code == "O03" THEN 
		CALL closed_sca_o3
	END
	IF .$code == "O04" THEN 
		CALL closed_sca_o4
	END
	IF .$code == "P01" THEN 
		CALL closed_sca_p1
	END
	IF .$code == "P02" THEN 
		CALL closed_sca_p2
	END
	IF .$code == "P03" THEN 
		CALL closed_sca_p3
	END
	IF .$code == "P04" THEN 
		CALL closed_sca_p4
	END
.END

.PROGRAM to_scarico_alto()
	JOINT SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-43.405,-10.42,-114.59,-1.3506,-75.967,-43.584] ;
	JOINT SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-100.41,-11.959,-104.39,0.28689,-87.975,9.7838] ;
.END

.PROGRAM to_carico_alto()
	JOINT SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-99.545,-12.03,-104.45,-0.61521,-88.738,12.249] ;
	JOINT SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-31.162,-13.654,-105.9,-1.307,-87.606,-56.101] ;
	JOINT SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-3.6516,12.478,-121.52,-1.6242,-45.246,-177.94] ;
.END


.PROGRAM fromcloset(.xx,.yy)
	.foo = 1
	.zdepth = 200
	DRAW 0,0,300,0,0,0,100
	DRAW -255,11,0,0,0,-90,100
	DRAW 0,0,0,0,0,-90,100
	DRAW .xx,.yy,0,0,0,0,100
	DRAW 0,0,-.zdepth,0,0,0,100
	MVWAIT 1mm
	CALL approachingscarico
	MVWAIT 1mm
	DRAW 0,0,.zdepth,0,0,0,100
	DRAW -.xx,-.yy,0,0,0,0,100
	DRAW 0,0,0,0,0,90,100
	DRAW 255,-11,0,0,0,90,100
	DRAW 0,0,-300,0,0,0,100
	MVWAIT 1mm
.END


;*****************************
; INBOUND FUNCTIONS
;*****************************

.PROGRAM approaching(.retval,.explore)
	SPEED 10
	.retval = 1
	.counter = 0
	DO
		DRAW 0,0,-1,0,0,0,100
		MVWAIT 1mm
		.counter = .counter + 1
	UNTIL (SIG(1001) OR SIG(1002))
	SPEED 100
.END

.PROGRAM approachingscarico()
	SPEED 10
	.retval = 1
	.counter = 0
	DO
		DRAW 0,0,-1,0,0,0,100
		MVWAIT 1mm
		.counter = .counter + 1
	UNTIL (SIG(1001) OR SIG(1002))
	SIGNAL 1
	DRAW 0,0,.counter,0,0,0,100
	SPEED 100
.END

.PROGRAM approccing_bar_()
	.counter = 0
	DO
		DRAW 2,-2,-2,0,0,0,5
		MVWAIT 0.1
		.counter = .counter+1
	UNTIL (SIG(1001) OR SIG(1002) OR (.counter == 50))
	IF (SIG(1001) OR SIG(1002)) THEN
	    SIGNAL 1
    	SPEED 100
  	END
.END

.PROGRAM going(.xx,.yy,.zz,.oo,.aa,.tt)
	.eff = .tt
	HOME 1
	MVWAIT 1mm
	; compute the shift
	.dx = tool_length * (1-cos(.eff))
	.dy = tool_length * sin(.eff)
	DRIVE 6,.eff,100
	DRAW .xx+.dx,.yy+.dy,.zz,0,0,0,100
	MVWAIT 1mm
.END

.PROGRAM dropoff()
	HOME 2
	JOINT SPEED5 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[97.88,27.238,-142.53,-143.8,-23.031,59.305];
	JOINT SPEED5 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[91.622,43.227,-139.05,-118.76,-51.052,46.282] ;
	MVWAIT 1 MM
	SIGNAL -1
.END

.PROGRAM act_inbound(.xx,.yy,.zz,.oo,.aa,.tt)
	SPEED 100
	.trial = 0
	.retval = 0
	DO
		CALL going(.xx,.yy,.zz,.oo,.aa,.tt)
		CALL approaching(.catchval,0)
		IF (.catchval == 1) THEN
			SPEED 30
			SIGNAL 1
			TWAIT 1
			DRAW 0,0,-.zz,0,0,0,30
			HOME 2
			MVWAIT 1mm
			SPEED 100
			.retval = 1
		END
		.trial = .trial + 1
	UNTIL ((.retval == 1) OR (.trial == 3))
.END

.PROGRAM act_trash(.xg,.yg,.zg,.gs,.xx,.yy,.zz)
	CALL recupera(.xg,.yg,.zg,.gs)
	HOME 2
	DRAW .xx,.yy,.zz,0,0,0,100
	MVWAIT 1mm
	SIGNAL -1
	HOME 2
.END


;*****************************
; RAK FUNCTIONS
;*****************************

.PROGRAM recupera(.xxg,.yyg,.zzg,.ggs)
	.zbordo = 30
	.zpunto = 47
	.zsicurezza = 5
	JOINT SPEED5 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[97.881,27.236,-142.53,-143.8,-23.029,59.307]
	JOINT SPEED5 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[69.029,71.443,-129.3,-108.68,-57.131,68.871]
	.zact = .zbordo + .zpunto - .zzg - .zsicurezza
	TDRAW 0,0,.zact,0,0,0,100
	TDRAW .xxg,.yyg,0,0,0,0,100
	CALL approccing_bar_
	DRAW 0,0,500,0,0,0,100
	HOME 2
.END

.PROGRAM gotooutrack()
	.$code = $outcloset
	CALL center_scarico
	MVWAIT 1mm	
	IF .$code == "M01" THEN 
		CALL scarico_m1
	END
	IF .$code == "M02" THEN 
		CALL scarico_m2
	END
	IF .$code == "M03" THEN 
		CALL scarico_m3
	END
	IF .$code == "M04" THEN 
		CALL scarico_m4
	END
	IF .$code == "N01" THEN 
		CALL scarico_n1
	END
	IF .$code == "N02" THEN 
		CALL scarico_n2
	END
	IF .$code == "N03" THEN 
		CALL scarico_n3
	END
	IF .$code == "N04" THEN 
		CALL scarico_n4
	END
	IF .$code == "O01" THEN 
		CALL scarico_o1
	END
	IF .$code == "O02" THEN 
		CALL scarico_o2
	END
	IF .$code == "O03" THEN 
		CALL scarico_o3
	END
	IF .$code == "O04" THEN 
		CALL scarico_o4
	END
	IF .$code == "P01" THEN 
		CALL scarico_p1
	END
	IF .$code == "P02" THEN 
		CALL scarico_p2
	END
	IF .$code == "P03" THEN 
		CALL scarico_p3
	END
	IF .$code == "P04" THEN 
		CALL scarico_p4
	END
	IF .$code == "Q01" THEN 
		CALL scarico_q1
	END
	IF .$code == "Q02" THEN 
		CALL scarico_q2
	END
	IF .$code == "Q03" THEN 
		CALL scarico_q3
	END
	IF .$code == "Q04" THEN 
		CALL scarico_q4
	END
.END

.PROGRAM center_cass()
	;LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[89.842,22.874,-124.66,2.0465,-32.907,3.8314] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-3.6533,12.477,-121.52,-1.622,-45.248,-177.94] ;
.END

.PROGRAM scarico_to_carico()
	JOINT SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-3.6533,12.477,-121.52,-1.622,-45.248,-177.94] ;
.END

.PROGRAM gotorack()
	.$code = $closet
	CALL center_cass
	CALL dispatch_carico(.$code)
.END

.PROGRAM dispatch_carico(.$code)
	IF .$code == "A01" THEN 
		CALL cassetto_a1
	END
	IF .$code == "A02" THEN 
		CALL cassetto_a2
	END
	IF .$code == "A03" THEN 
		CALL cassetto_a3
	END
	IF .$code == "A04" THEN 
		CALL cassetto_a4
	END
	IF .$code == "A05" THEN 
		CALL cassetto_a5
	END
	IF .$code == "A06" THEN 
		CALL cassetto_a6
	END
	IF .$code == "A07" THEN 
		CALL cassetto_a7
	END
	IF .$code == "A08" THEN 
		CALL cassetto_a8
	END
	IF .$code == "A09" THEN 
		CALL cassetto_a9
	END
	IF .$code == "A10" THEN 
		CALL cassetto_a10
	END
	IF .$code == "A11" THEN 
		CALL cassetto_a11
	END
	IF .$code == "B01" THEN 
		CALL cassetto_b1
	END
	IF .$code == "B02" THEN 
		CALL cassetto_b2
	END
	IF .$code == "B03" THEN 
		CALL cassetto_b3
	END
	IF .$code == "B04" THEN 
		CALL cassetto_b4
	END
	IF .$code == "B05" THEN 
		CALL cassetto_b5
	END
	IF .$code == "B06" THEN 
		CALL cassetto_b6
	END
	IF .$code == "B07" THEN 
		CALL cassetto_b7
	END
	IF .$code == "B08" THEN 
		CALL cassetto_b8
	END
	IF .$code == "B09" THEN 
		CALL cassetto_b9
	END
	IF .$code == "B10" THEN 
		CALL cassetto_b10
	END
	IF .$code == "B11" THEN 
		CALL cassetto_b11
	END
	IF .$code == "C01" THEN 
		CALL cassetto_c1
	END
	IF .$code == "C02" THEN 
		CALL cassetto_c2
	END
	IF .$code == "C03" THEN 
		CALL cassetto_c3
	END
	IF .$code == "C04" THEN 
		CALL cassetto_c4
	END
	IF .$code == "C05" THEN 
		CALL cassetto_c5
	END
	IF .$code == "C06" THEN 
		CALL cassetto_c6
	END
	IF .$code == "C07" THEN 
		CALL cassetto_c7
	END
	IF .$code == "C08" THEN 
		CALL cassetto_c8
	END
	IF .$code == "C09" THEN 
		CALL cassetto_c9
	END
	IF .$code == "C10" THEN 
		CALL cassetto_c10
	END
	IF .$code == "C11" THEN 
		CALL cassetto_c11
	END
.END

.PROGRAM openrack()
	DRAW 0,-490,0,0,0,0,100
	MVWAIT 1mm
.END

.PROGRAM closet(.xx,.yy)
	DRAW 0,0,300,0,0,0,100
	DRAW -255,11,0,0,0,-90,100
	DRAW 0,0,0,0,0,-90,100
	DRAW .xx,.yy,0,0,0,0,100
	DRAW 0,0,-150,0,0,0,100
	MVWAIT 1mm
	SIGNAL -1
	DRAW 0,0,150,0,0,0,100
	DRAW -.xx,-.yy,0,0,0,0,100
	DRAW 0,0,0,0,0,90,100
	DRAW 255,-11,0,0,0,90,100
	DRAW 0,0,-300,0,0,0,100
	MVWAIT 1mm
.END

.PROGRAM closerack()
	DRAW 0,490,0,0,0,0,100
	DRAW 0,0,+50,0,0,0,100
	DRAW 0,-200,0,0,0,0,100
	CALL center_cass
	MVWAIT 1mm
.END

.PROGRAM act_rak(.xg,.yg,.zg,.gs,.xx,.yy)
	SPEED 100
	CALL recupera(.xg,.yg,.zg,.gs)
	CALL gotorack
	CALL openrack
	CALL closet(.xx,.yy)
	CALL closerack
	HOME 2
.END


;*****************************
; DECODING FUNCTIONS
;*****************************

.PROGRAM decode_inbound(.$p,.x,.y,.z,.o,.a,.t)
	.i = 0
	.plen = 0
	DO
		.$temp = $DECODE(.$p,",",0)
		IF .i <= 4 THEN 
			CALL strlen(.$p,.plen)
			.plen = .plen - 1
			.$p = $MID(.$p,2,.plen)
		END
		.tmp = VAL(.$temp)
		.value[.i] = .tmp
		.i = .i + 1		
	UNTIL .i == 6
	.x = .value[0]
	.y = .value[1]
	.z = .value[2]	
	.o = .value[3]	
	.a = .value[4]	
	.t = .value[5]	
.END

.PROGRAM decode_rak(.$p,.xgri,.ygri,.zgri,.gsid,.xclo,.yclo)
	.i = 0
	.plen = 0
	DO
		.$temp = $DECODE(.$p,",",0)
		IF .i <= 5 THEN 
			CALL strlen(.$p,.plen)
			.plen = .plen - 1
			.$p = $MID(.$p,2,.plen)
		END
		.tmp = VAL(.$temp)
		.$strval[.i] = .$temp
		.value[.i] = .tmp
		.i = .i + 1		
	UNTIL .i == 7
	.xgri = .value[0]
	.ygri = .value[1]
	.zgri = .value[2]	
	.gsid = .value[3]	
	$closet = .$strval[4]
	.xclo = .value[5]
	.yclo = .value[6]
.END

.PROGRAM decode_trash(.$p,.xgri,.ygri,.zgri,.gsid,.x,.y,.z)
	.i = 0
	.plen = 0
	DO
		.$temp = $DECODE(.$p,",",0)
		IF .i <= 5 THEN 
			CALL strlen(.$p,.plen)
			.plen = .plen - 1
			.$p = $MID(.$p,2,.plen)
		END
		.tmp = VAL(.$temp)
		.value[.i] = .tmp
		.i = .i + 1		
	UNTIL .i == 7
	.xgri = .value[0]
	.ygri = .value[1]
	.zgri = .value[2]	
	.gsid = .value[3]
	.x = .value[4]
	.y = .value[5]
	.z = .value[6]	
.END

.PROGRAM decode_get(.$p,.xclo,.yclo,.last)
	.i = 0
	.plen = 0
	DO
		.$temp = $DECODE(.$p,",",0)
		IF .i <= 3 THEN 
			CALL strlen(.$p,.plen)
			.plen = .plen - 1
			.$p = $MID(.$p,2,.plen)
		END
		.tmp = VAL(.$temp)
		.$strval[.i] = .$temp
		.value[.i] = .tmp
		.i = .i + 1		
	UNTIL .i == 5
	$closet = .$strval[0]
	.xclo = .value[1]
	.yclo = .value[2]
	$outcloset = .$strval[3]
	.$tmp = .$strval[4]
	.$tmp = $LEFT(.$tmp,1)
	.last = VAL(.$tmp)
.END

.PROGRAM decode_open(.$p)
	.i = 0
	.plen = 0
	DO
		.$temp = $DECODE(.$p,",",0)
		IF .i <= -1 THEN 
			CALL strlen(.$p,.plen)
			.plen = .plen - 1
			.$p = $MID(.$p,2,.plen)
		END
		.tmp = VAL(.$temp)
		.$strval[.i] = .$temp
		.value[.i] = .tmp
		.i = .i + 1	
	UNTIL .i == 1
	$outcloset = .$strval[0]
	;CALL strlen(.$p,.plen)
	$outcloset = $MID(.$strval[0],1,3)
.END

.PROGRAM decode_close(.$p)
	CALL decode_open(.$p)
.END


;***************************
; COMMUNICATION FUNCTIONS
;***************************

.PROGRAM receive()
	.mchar = 2
	.max_length = 255
	.port = 49152
	UDP_RECVFROM .ret,.port,.$cnt[0],.mchar,tout,ip[1],.max_length
	IF .ret == 0 THEN
		commflag = 1
	END
	$msg = .$cnt[0]
.END

.PROGRAM send()
	.mchar = 1
	.outport = 49156
	UDP_SENDTO .ret,ip[1],.outport,$omsg[0],.mchar,tout
.END

;***************************
; MAIN PROGRAM
;***************************

.PROGRAM logic()
	; Defensive assignment
	$omsg[0] = "X"
	.$code = $MID($msg,1,3)
	IF (commflag == 1) THEN
		IF (.$code == "TST") THEN
			$omsg[0] = "0"
		END
		IF (.$code == "INB") THEN
			$omsg[0] = "X"
			CALL strlen($msg,.ll)
			.trail = .ll - 5
			.$payload = $MID($msg,5,.trail)
			CALL decode_inbound(.$payload,.inbx,.inby,.inbz,.inbo,.inba,.inbt)
			CALL act_inbound(.inbx,.inby,.inbz,.inbo,.inba,.inbt)
			CALL dropoff
			$omsg[0] = "1"
		END
		IF (.$code == "RAK") THEN
			$omsg[0] = "X"
			CALL strlen($msg,.ll)
			.trail = .ll - 5
			.$payload = $MID($msg,5,.trail)
			CALL decode_rak(.$payload,.xgrip,.ygrip,.zgrip,.gripside,.xcloset,.ycloset)
			CALL act_rak(.xgrip,.ygrip,.zgrip,.gripside,.xcloset,.ycloset)
			$omsg[0] = "2"
		END
		IF (.$code == "TRS") THEN
			$omsg[0] = "X"
			CALL strlen($msg,.ll)
			.trail = .ll - 5
			.$payload = $MID($msg,5,.trail)
			CALL decode_trash(.$payload,.xgrip,.ygrip,.zgrip,.gripside,.xtrash,.ytrash,.ztrash)
			CALL act_trash(.xgrip,.ygrip,.zgrip,.gripside,.xtrash,.ytrash,.ztrash)
			$omsg[0] = "3"
		END
		IF (.$code == "OPE") THEN
			$omsg[0] = "X"
			CALL strlen($msg,.ll)
			.trail = .ll - 5
			.$payload = $MID($msg,5,.trail)
			CALL decode_open(.$payload)
			CALL act_open
			$omsg[0] = "4"
		END
		IF (.$code == "GET") THEN
			$omsg[0] = "X"
			CALL strlen($msg,.ll)
			.trail = .ll - 5
			.$payload = $MID($msg,5,.trail)
			CALL decode_get(.$payload,.xclo,.yclo,.last_action)
			CALL act_get(.xclo,.yclo,.last_action)
			$omsg[0] = "5"
		END
		IF (.$code == "CLO") THEN
			$omsg[0] = "X"
			CALL strlen($msg,.ll)
			.trail = .ll - 5
			.$payload = $MID($msg,5,.trail)
			CALL decode_close(.$payload)
			CALL act_close
			$omsg[0] = "6"
		END
	END
.END


.PROGRAM main()
	debugflag = 0
	swap = 1
	PREFETCH.SIGINS ON
	maxDZ = 380.00
	tout = 100
	port = 49152
	outport = 49156
	max_length = 255
	mchar = 2
	$msg = "A"
	$omsg[0] = "X"
	$closet = ""
	$outcloset = ""
	commflag = 0
	tool_length = 190
	DRAW 0,0,300,0,0,0,100
	HOME 2
loop:
	commflag = 0
	CALL receive
	CALL logic
	CALL send
	GOTO loop
exit:
.END


;*****************************
; CLOSET FUNCTIONS
;*****************************

.PROGRAM cassetto_d1()
	PRINT "CASSETTO"
.END

.PROGRAM cassetto_d2()
	PRINT "CASSETTO"
.END

.PROGRAM cassetto_d3()
	PRINT "CASSETTO"
.END

.PROGRAM cassetto_d4()
	PRINT "CASSETTO"
.END

.PROGRAM cassetto_d5()
	PRINT "CASSETTO"
.END

.PROGRAM cassetto_a1()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-31.299,15.416,-73.386,-2.2714,-89.693,-147.01] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-27.656,20.542,-67.09,-2.1085,-90.65,-152.69] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-27.507,20.114,-69.418,-2.0515,-88.679,-154.51] ;
.END

.PROGRAM cassetto_a10()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-30.035,66.817,-84.725,-4.0319,-27.606,-144.71] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-28.08,69.989,-76.916,-3.4445,-32.174,-147.32] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-28.077,72.247,-75.643,-3.5454,-31.185,-147.2] ;
.END

.PROGRAM cassetto_a11()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-29.882,81.009,-73.55,-3.6492,-25.12,-145.12] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-28.035,83.92,-65.679,-3.0675,-30.026,-147.62] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-28.035,88.848,-61.041,-3.0982,-29.732,-147.58] ;
.END

.PROGRAM cassetto_a2()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-29.418,13.134,-82.907,-2.5045,-81.475,-152.39] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-27.261,19.67,-74.88,-2.3982,-82.876,-154.62] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-27.261,19.97,-76.872,-2.4124,-80.586,-154.53] ;
.END

.PROGRAM cassetto_a3()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-29.458,14.685,-88.702,-1.3285,-76.358,-151.77] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-27.244,22.131,-79.318,-1.3073,-78.246,-154.03] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-27.244,22.634,-80.571,-1.3161,-76.489,-153.99] ;
.END

.PROGRAM cassetto_a4()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-29.551,18.062,-91.645,-0.71611,-70.087,-150.69] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-27.564,24.458,-83.278,-0.69997,-72.035,-152.71] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-27.564,25.332,-84.397,-0.70851,-70.038,-152.69] ;
.END

.PROGRAM cassetto_a5()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-29.422,22.036,-95.269,-1.392,-62.649,-150.42] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-27.282,28.127,-86.863,-1.362,-64.917,-152.62] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-27.282,29.714,-87.809,-1.3962,-62.384,-152.55] ;
.END

.PROGRAM cassetto_a6()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-28.974,27.71,-95.059,-0.78538,-58.521,-152.19] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-27.345,32.188,-88.468,-0.81036,-60.62,-153.83] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-27.306,34.45,-88.875,-0.83472,-57.951,-153.83] ;
.END

.PROGRAM cassetto_a7()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-28.863,32.302,-97.71,-1.7343,-49.953,-150.63] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-26.974,37.072,-90.144,-1.6622,-52.706,-152.63] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-26.974,39.205,-90.194,-1.7172,-50.522,-152.54] ;
.END

.PROGRAM cassetto_a8()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-28.835,39.476,-96.239,-2.2669,-43.782,-149.94] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-27.217,42.937,-89.733,-2.1293,-46.782,-151.74] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-27.193,45.37,-89.235,-2.2021,-44.847,-151.66] ;
.END

.PROGRAM cassetto_a9()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-29.483,49.91,-93.773,-3.6976,-34.985,-145.81] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-27.763,53.255,-87.007,-3.3452,-38.34,-147.93] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-27.725,57.055,-85.318,-3.51,-36.231,-147.76] ;
.END

.PROGRAM cassetto_b1()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-3.6774,1.7849,-87.868,-1.1526,-90.063,-179.76] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-3.3351,10.223,-80.018,-1.1507,-89.473,-180.09] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-3.3531,9.7129,-81.767,-1.151,-88.23,-180.05] ;
.END

.PROGRAM cassetto_b10()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-4.5188,60.821,-101.32,-4.8378,-15.497,-170.77] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-4.1001,63.779,-92.429,-3.4891,-21.405,-172.6] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-4.1001,66.674,-90.598,-3.6669,-20.34,-172.41] ;
.END

.PROGRAM cassetto_b11()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-4.9421,76.257,-89.946,-5.2822,-13.134,-170.65] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-4.4972,78.647,-81.136,-3.571,-19.53,-172.88] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-4.4972,83.576,-76.86,-3.6934,-18.875,-172.75] ;
.END

.PROGRAM cassetto_b2()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-4.0135,0.54794,-96.641,-1.1672,-82.036,-178.47] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-3.5945,9.9158,-86.582,-1.1596,-82.724,-178.9] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-3.5945,10.322,-88.581,-1.1668,-80.318,-178.85] ;
.END

.PROGRAM cassetto_b3()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-3.8714,4.9631,-99.482,-1.1988,-75.209,-178.37] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-3.5974,11.169,-92.561,-1.3101,-74.332,-178.59] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-3.5896,12.142,-93.938,-1.244,-73.058,-178.59] ;
.END

.PROGRAM cassetto_b4()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-4.5381,5.8828,-106.46,-1.4117,-66.227,-175.32] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-4.087,14.334,-96.724,-1.2896,-68.584,-175.87] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-4.087,15.236,-97.7,-1.3101,-66.706,-175.82] ;
.END

.PROGRAM cassetto_b5()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-4.0668,11.721,-109.12,-1.361,-58.844,-177.3] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-3.7199,18.692,-100.45,-1.3357,-60.533,-177.69] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-3.7196,20.219,-101.22,-1.3712,-58.241,-177.63] ;
.END

.PROGRAM cassetto_b6()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-3.7189,17.829,-109.73,-1.251,-52.212,-178.26] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-3.4436,23.348,-102.27,-1.2146,-54.156,-178.59] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-3.4436,25.345,-102.72,-1.2579,-51.708,-178.52] ;
.END

.PROGRAM cassetto_b7()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-4.7876,24.287,-110.37,-1.5973,-45.77,-174.29] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-4.4656,28.876,-103.51,-1.8855,-45.527,-174.41] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-4.4656,31.238,-103.53,-1.9677,-43.142,-174.3] ;
.END

.PROGRAM cassetto_b8()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-4.7687,30.933,-110.68,-2.1973,-35.992,-173.59] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-4.6932,35.31,-103.3,-2.0474,-38.994,-173.86] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-4.6932,37.993,-102.89,-2.1584,-36.72,-173.72] ;
.END

.PROGRAM cassetto_b9()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-6.2469,44.55,-108.45,-3.4208,-24.704,-168.99] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-5.889,47.291,-102.4,-3.0106,-28.001,-169.79] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-5.8886,49.773,-101.44,-3.1741,-26.477,-169.61] ;
.END
.PROGRAM cassetto_c1()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[23.161,8.477,-81.014,-0.71168,-89.35,-205.16] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[21.082,17.091,-70.867,-0.75659,-90.915,-203.1] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[21.127,16.852,-73.589,-0.75912,-88.431,-203.11] ;
.END

.PROGRAM cassetto_c10()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[22.204,62.878,-94.503,0.37197,-19.552,-203.12] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[20.468,66.094,-85.824,0.0718,-25.013,-201.11] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[20.468,69.904,-83.309,0.075596,-23.715,-201.11] ;
.END

.PROGRAM cassetto_c11()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[22.238,77.692,-83.949,0.011387,-15.287,-200.54] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[20.435,80.427,-75.267,-0.26063,-21.237,-198.48] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[20.435,85.605,-70.644,-0.26727,-20.677,-198.48] ;
.END

.PROGRAM cassetto_c2()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[23.341,7.6303,-89.149,-0.81795,-82.561,-205.11] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[21.039,16.756,-78.464,-0.84484,-84.153,-202.83] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[21.039,17.067,-80.355,-0.84895,-81.947,-202.79] ;
.END

.PROGRAM cassetto_c3()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[22.359,12.235,-91.566,-0.82396,-75.448,-203.55] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[20.876,18.216,-84.288,-0.84231,-76.767,-202.09] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[20.876,18.775,-85.576,-0.84959,-74.916,-202.06] ;
.END

.PROGRAM cassetto_c4()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[23.561,11.291,-100.11,-0.68226,-67.298,-205.52] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[21.088,20.403,-88.859,-0.7354,-69.462,-203.05] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[21.088,21.32,-89.939,-0.74521,-67.464,-203.02] ;
.END

.PROGRAM cassetto_c5()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[23.398,15.904,-104.01,-1.2168,-59.594,-205.33] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[20.862,24.823,-92.247,-1.2073,-62.48,-202.85] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[20.862,25.929,-92.857,-1.2304,-60.767,-202.81] ;
.END

.PROGRAM cassetto_c6()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[22.922,21.91,-103.23,-1.7102,-55.057,-205.32] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[20.93,28.69,-93.64,-1.646,-57.91,-203.43] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[20.928,30.976,-94.227,-1.7033,-55.036,-203.33] ;
.END

.PROGRAM cassetto_c7()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[22.916,27.238,-105.01,-1.053,-46.948,-204.46] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[20.84,33.706,-95.066,-1.0346,-50.45,-202.44] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[20.84,36.341,-95.129,-1.0818,-47.75,-202.38] ;
.END

.PROGRAM cassetto_c8()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[22.568,34.979,-102.58,1.5325,-42.275,-204.96] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[21.035,40.004,-95.015,1.46,-44.785,-203.33] ;avv_cassetto
	LINEAR SPEED5 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[21.035,42.67,-94.586,1.5205,-42.549,-203.42] ;
.END

.PROGRAM cassetto_c9()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[22.588,46.528,-101.76,-1.2333,-30.336,-202.66] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[20.699,50.869,-92.727,-1.163,-35.047,-200.89] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[20.699,53.948,-91.506,-1.2238,-33.185,-200.82] ;
.END

;******************************
; COLONNE SCARICO
;******************************
.PROGRAM scarico_q1()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-141.69,43.452,-65.822,0.08635,-70.61,230.83] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-136.47,57.322,-48.379,-6.605,-68.371,227.75] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-136.47,58.029,-48.763,-6.6597,-67.285,227.89] ;
.END

.PROGRAM scarico_q2()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-142.16,53.788,-69.567,-6.7461,-52.486,235.23] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-136.15,64.942,-49.588,-5.5751,-60.706,227.84] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-136.09,67.389,-48.74,-4.7366,-59.808,227.49] ;
.END

.PROGRAM scarico_q3()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-142.21,65.788,-65.428,-7.6203,-44.689,236.59] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-136.19,78.034,-42.802,-5.9863,-54.429,228.63] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-136.23,81.933,-39.946,-6.073,-53.395,228.81] ;
.END

.PROGRAM scarico_q4()
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-142.21,82.246,-54.223,-8.4351,-39.484,237.69] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-136.23,95.019,-28.064,-6.1657,-52.197,228.96] ;
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-136.27,102.18,-19.403,-6.0486,-53.692,228.8] ;
.END

.PROGRAM scarico_p1()
        LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-127.92,12.752,-105.32,-4.934,-56.484,219.6] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-120.7,31.355,-88.167,-4.1559,-54.534,212.08] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-120.7,33.119,-88.758,-4.2865,-52.188,212.3] ;
.END

.PROGRAM scarico_p2()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-127.92,28.945,-108.96,-6.8856,-36.746,222.4] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-120.57,42.848,-89.056,-5.021,-42.185,213.27] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-120.63,45.668,-88.821,-5.3025,-39.611,213.69] ;
.END

.PROGRAM scarico_p3()
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-127.92,47.12,-104.85,-10.649,-22.836,226.7] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-120.75,56.989,-84.81,-6.3485,-32.342,215.1] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-120.85,60.574,-83.369,-6.7679,-30.217,215.67] ;
.END

.PROGRAM scarico_p4()
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-127.92,63.897,-96.419,-16.403,-14.712,232.76] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-120.93,73.428,-75.626,-8.0407,-25.154,217.18] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-120.85,77.363,-72.411,-8.2438,-24.437,217.34] ;
.END

.PROGRAM scarico_o1()
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-101.22,-6.5012,-129.6,-1.6128,-49.613,190.83] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-97.999,19.459,-104.41,-1.0893,-48.782,187.31] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-97.999,21.836,-105.12,-1.1491,-45.69,187.39] ;
.END

.PROGRAM scarico_o2()
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-101.22,11.927,-132.62,-2.6003,-28.178,192.08] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-97.901,33.127,-105.72,-1.4455,-33.802,187.69] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-97.913,36.043,-105.43,-1.5594,-31.171,187.84] ;
.END

.PROGRAM scarico_o3()
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-101.22,38.148,-127.44,-9.8164,-7.2181,199.53] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-98.195,50.779,-100.95,-2.3583,-20.929,188.99] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-98.195,53.189,-99.891,-2.513,-19.582,189.15] ;
.END

.PROGRAM scarico_o4()
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-99.262,60.732,-106.06,-9.4691,-5.9577,197.27] ;
 	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-98.888,67.533,-90.108,-15.453,-22.572,201.58] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-98.893,71.751,-87.208,-16.353,-21.301,202.56] ;
.END

.PROGRAM scarico_n1()
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-66.535,0.90878,-120.01,2.2438,-53.617,153.58] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-72.363,23.252,-100.34,1.6055,-50.785,159.7] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-72.363,24.93,-100.83,1.6574,-48.615,159.62] ;
.END

.PROGRAM scarico_n2()
 	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-66.782,18.636,-123.68,3.4363,-32.256,151.71] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-72.344,36.498,-101.29,2.1711,-36.605,158.42] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-72.377,38.589,-100.82,2.2568,-34.98,158.34] ;
.END

.PROGRAM scarico_n3()
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-66.78,40.209,-119.38,7.082,-15.04,147.77] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-72.485,52.48,-96.671,3.0026,-25.251,157.58] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-72.485,55.01,-95.535,3.1706,-23.856,157.39] ;
.END

.PROGRAM scarico_n4()
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-68.173,61.126,-107.51,7.2487,-5.3106,151.94] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-71.329,66.801,-88.748,25.528,-23.606,139.42] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-71.327,72.949,-84.458,27.505,-21.942,137.28] ;
.END

.PROGRAM scarico_m1()
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-46.305,28.193,-90.25,0.11608,-61.65,133.92] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-51.326,37.555,-78.767,10.822,-53.422,133.3] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-51.716,40.373,-78.153,7.7408,-53.977,135.23] ;
.END

.PROGRAM scarico_m2()
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-46.305,39.272,-92.143,0.13569,-48.678,133.89] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-51.872,49.016,-77.755,6.4684,-47.537,135.4] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-51.947,52.041,-77.002,6.7062,-45.272,135.12] ;
.END

.PROGRAM scarico_m3()
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-46.303,54.117,-88.497,0.16543,-37.48,133.85] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-52.035,62.038,-74.151,7.6497,-38.208,133.92] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-52.082,66.186,-71.856,7.9768,-36.363,133.55] ;
.END

.PROGRAM scarico_m4()
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-46.301,71.353,-78.872,0.20053,-29.867,133.8] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-52.115,79.631,-61.74,12.469,-31.152,129.52] ;
  	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-52.181,83.976,-57.872,12.631,-30.676,129.39] ;
.END

.PROGRAM center_scarico()
	JOINT SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-103.68,13.792,-142.96,0.34287,-23.199,194.33] ;
.END

.PROGRAM center_out_scarico()
	;per l'uscita dai cassetti utilizzare come inerpolazione LINEAR
      ;per andare in center_scarico da HOME2 e viceversa utilizzare come interpolazione JOINT
	LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-103.68,13.792,-142.96,0.34287,-23.199,194.33] ;
.END

;*****************************
; CLOSED DOPO SCARICO
;*****************************

.PROGRAM closed_sca_q1()
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-141.37,41.614,-51.565,-0.32263,-87.291,49.924] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-146.22,35.047,-61.764,-3.1852,-83.15,-123.8] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-145.33,41.971,-74.521,-3.5353,-63.448,-123.49] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-135.81,59.909,-44.628,-3.2127,-74.858,-133.77] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-136.43,57.982,-47.386,-7.7472,-70.908,-131.59] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-147.02,39.698,-77.542,-9.0851,-60.601,-118.97] ;
.END
.PROGRAM closed_sca_q2()
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-142.21,42.132,-65.137,0.57725,-73.354,51.103] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-146.82,37.755,-75.363,-1.4996,-67.508,237.26] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-146.57,51.794,-76.549,-1.7593,-52.279,237.52] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-135.88,67.939,-47.737,-4.6961,-60.246,227.22] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-136.11,65.594,-49.253,-4.68,-61.083,227.39] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-146.15,49.555,-78.029,-6.2855,-49.214,239.29] ;
.END
.PROGRAM closed_sca_q3()
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-141.55,52.227,-66.372,1.0052,-62.979,49.143] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-146.1,45.633,-77.629,-0.198,-55.858,235.43] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-146.64,65.784,-72.206,-9.1436,-38.448,242.79] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-136.14,81.939,-39.763,-6.0502,-53.559,228.69] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-136.36,78.733,-42.844,-6.0641,-53.699,228.9] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-146.04,63.807,-72.399,-8.7574,-40.138,241.71] ;
.END
.PROGRAM closed_sca_q4()
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-142.11,63.576,-65.933,0.24165,-51.828,51.764] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-146.88,57.662,-76.724,-8.5069,-42.032,242.17] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-146.88,82.327,-61.023,-10.428,-33.185,244.59] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-136.11,102.66,-18.228,-5.9775,-54.372,228.54] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-136.11,96.799,-25.608,-6.097,-52.859,228.74] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-146.82,78.326,-64.262,-10.212,-33.93,244.27] ;
.END
.PROGRAM closed_sca_p1()
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-125.79,10.376,-93.143,-0.17491,-76.912,35.021] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-130.93,0.378,-103.98,-4.6677,-70.383,221.44] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-130.93,14.407,-114.91,-6.1704,-45.527,224.2] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-120.53,33.55,-88.1,-4.2536,-52.4,212.1] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-120.68,31.891,-88.249,-4.1907,-53.912,212.12] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-130.56,13.226,-113.81,-5.9025,-47.76,223.48] ;
.END
.PROGRAM closed_sca_p2()
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-125.39,17.544,-100,0.17491,-62.733,36.422] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-130.2,8.5638,-111.14,-5.2854,-55.033,222.18] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-130.2,31.593,-113.9,-8.8397,-29.428,226.86] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-120.51,45.92,-88.368,-5.2601,-39.806,213.53] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-120.67,43.61,-89.322,-5.1393,-41.168,213.52] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-129.22,30.149,-112.45,-7.9717,-32.199,224.93] ;
.END
.PROGRAM closed_sca_p3()
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-125.82,29.615,-104.53,0.25905,-46.7,35.873] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-130.82,22.655,-115.13,-7.2854,-37.103,225.58] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-130.82,49.964,-108.6,-15.473,-16.668,234.61] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-120.69,60.863,-82.738,-6.6664,-30.547,215.4] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-120.81,58.77,-84.122,-6.5547,-31.256,215.38] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-128.41,49.456,-105.16,-12.083,-20.275,228.7] ;
.END
.PROGRAM closed_sca_p4()
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-125.89,40.199,-104.25,1.5265,-37.102,33.602] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-130.75,34.302,-113.66,-2.0718,-30.588,221.69] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-131.21,69.105,-98.093,-30.672,-8.7002,250.54] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-120.65,77.682,-71.601,-8.0442,-24.911,216.93] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-120.85,75.145,-74.144,-8.0945,-24.916,217.18] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-128.44,67.913,-95.054,-20.022,-12.239,236.99] ;
.END
.PROGRAM closed_sca_o1()
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-99.573,-5.0853,-108.05,0.010122,-78.318,8.4732] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-101.32,-17.616,-118.55,-0.045231,-77.778,189.99] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-101.54,-2.1736,-133.35,-1.9193,-41.539,191.53] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-97.957,22.205,-104.61,-1.1374,-45.829,187.34] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-97.999,20.4,-104.71,-1.1108,-47.536,187.34] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-101.38,-3.3587,-131.99,-1.802,-44.085,191.24] ;
.END
.PROGRAM closed_sca_o2()
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-99.647,0.8947,-118.66,0.047129,-61.647,10.84] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-101.43,-11.332,-129.94,-1.5492,-54.095,190.9] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-101.43,19.239,-133.75,-3.7184,-19.746,193.49] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-97.87,36.342,-104.9,-1.5372,-31.398,187.78] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-97.898,34.304,-105.51,-1.4819,-32.825,187.74] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-100.59,19.693,-129.29,-2.8578,-23.72,191.78] ;
.END
.PROGRAM closed_sca_o3()
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-99.848,15.701,-121.42,-0.0006326,-44.026,9.4596] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-101.52,6.5269,-132.73,-0.070851,-39.597,191.73] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-101.65,43.488,-126.17,-8.6803,-5.3972,198.9] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-98.161,53.351,-99.502,-2.4716,-19.81,189.07] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-98.187,51.846,-100.41,-2.4131,-20.404,189.03] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-101,43.378,-123.25,-11.216,-6.1791,200.72] ;
.END
.PROGRAM closed_sca_o4()
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-99.845,38.245,-118.15,2.7069,-24.565,8.7836] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-102.58,34.117,-127.94,-18.993,-18.907,210.06] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-102.58,66.698,-112.15,-79.28,-6.1615,271.24] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-98.871,71.826,-86.978,-16.24,-21.45,202.42] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-98.906,69.598,-88.86,-15.999,-21.783,202.19] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-101.03,65.097,-106.22,-35.276,-10.226,224.26] ;
.END
.PROGRAM closed_sca_n1()
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-70.44,-1.0135,-105.99,0.77146,-76.004,-16.362] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-65.488,-11.977,-115.96,2.0208,-70.576,153.2] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-65.488,3.5627,-127.58,2.7768,-43.444,151.85] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-72.441,25.25,-100.38,1.6419,-48.748,159.71] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-72.372,23.707,-100.43,1.6157,-50.242,159.69] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-67.918,8.3208,-120.04,2.3235,-46.138,154.68] ;
.END
.PROGRAM closed_sca_n2()
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-68.967,8.5628,-114.52,0.18788,-57.8,-22.573] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-65.407,-2.2028,-125.91,2.5329,-50.888,151.65] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-65.407,22.796,-127.94,4.8549,-23.91,148.81] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-72.426,38.751,-100.53,2.2397,-35.104,158.4] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-72.324,36.629,-101.41,2.1885,-36.345,158.37] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-67.858,24.846,-121.06,3.6182,-28.621,152.51] ;
.END
.PROGRAM closed_sca_n3()
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-69.205,23.125,-116.6,0.053771,-41.691,-20.078] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-65.652,14.73,-128.52,0.21667,-35.333,153.2] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-65.355,45.294,-122,15.19,-7.5397,138.12] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-72.536,55.141,-95.223,3.1371,-24.031,157.48] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-72.457,52.956,-96.578,3.0583,-24.858,157.49] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-67.08,44.147,-118.54,8.753,-11.954,146.35] ;
.END
.PROGRAM closed_sca_n4()
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-68.766,40.076,-115.38,-2.9214,-24.695,-19.444] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-63.887,36.226,-124.77,31.113,-20.107,125.96] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-63.887,67.274,-109.36,80.329,-10.383,75.336] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-71.419,73.118,-83.954,27.132,-22.224,137.77] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-71.328,71.487,-85.522,27.059,-22.291,137.76] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-66.969,66.678,-102.97,51.429,-12.999,107.93] ;
.END
.PROGRAM closed_sca_m1()
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-46.884,19.05,-83.67,0.85654,-78.048,-43.263] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-40.763,11.155,-94.19,8.1837,-68.433,125.82] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-40.763,23.556,-103.48,10.425,-47.023,121.7] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-51.811,40.582,-77.818,7.7149,-54.088,135.35] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-51.583,38.939,-78.225,7.6349,-55.336,135.31] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-43.73,25.72,-98.041,9.5324,-49.82,125.64] ;
.END
.PROGRAM closed_sca_m2()
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-47.003,26.113,-92.115,0.84895,-61.479,-42.104] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-41.109,19.548,-101.12,7.0886,-54.655,124.9] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-41.109,37.756,-102.72,10.093,-35.065,120.72] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-52.076,52.297,-76.535,6.6657,-45.467,135.29] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-51.912,50.311,-77.428,6.5677,-46.565,135.29] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-42.946,37.518,-99.922,9.1863,-37.846,123.57] ;
.END
.PROGRAM closed_sca_m3()
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-46.529,37.214,-94.009,0.60951,-49.457,-43.6] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-41.296,31.129,-103.8,8.8375,-40.532,122.47] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-41.296,54.672,-97.475,14.422,-23.64,115.95] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-52.226,66.438,-71.324,7.9037,-36.624,133.77] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-52.064,63.568,-73.299,7.7687,-37.521,133.79] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-42.165,52.318,-97.408,13.05,-25.89,118.29] ;
.END
.PROGRAM closed_sca_m4()
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-47.451,53.466,-87.315,1.2371,-40.789,-45.87] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-42.806,48.509,-97.47,0.79803,-33.779,131.5] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-41.953,73.688,-84.454,27.646,-16.866,103.45] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-52.345,84.279,-57.175,12.452,-31.035,129.75] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-52.204,81.835,-59.673,12.505,-30.998,129.56] ;
  LINEAR SPEED9 ACCU1 TIMER0 TOOL1 WORK0 CLAMP1 (OFF,0,0,O) 2 (OFF,0,0,O) 3 (OFF,0,0,O) 4 (OFF,0,0,O) OX= WX= #[-42.544,71.806,-85.092,25.771,-17.867,106] ;
.END

.PROGRAM old_close_out_closet()
	; ultimo deposito effettuato
	; partendo con le ventose sul bordo della cesta in Z
	; in X mi trovo nel mezzo della cesta
	; angolazione AOT mi trovo allo stesso modo del secondo passo di to_scarico_alto
	DRAW 78,0,0,0,0,-180,100
	DRAW 0,0,-619,0,0,0,100
	DRAW -410,0,0,0,0,0,100
	DRAW 0,0,40,0,0,0,100
	DRAW 100,0,0,0,0,0,100
.END

;*****************************
; UTILITY FUNCTIONS
;*****************************

.PROGRAM debug(.$m)
	IF debugflag THEN
		PRINT .$m
	END
.END

.PROGRAM strlen(.$s,.len)
	.len = 1
	DO
		.$c = $MID(.$s,.len,1)
		.len = .len + 1
	UNTIL (.$c == "*")
.END

