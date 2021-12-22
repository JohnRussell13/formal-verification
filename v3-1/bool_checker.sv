checker bool_checker ( clk, rst, 
			HELP1, RT1, RDY1, START1, ENDD1,
			ER2,
			ER3, RDY3,
			HELP4, RDY4, START4,
			ENDD5, STOP5, ER5, RDY5, START5,
			ENDD6, STOP6, ER6, RDY6,
			ENDD7, START7, STATUS_VALID7, INSTARTSV7,
			RT8, ENABLE8,
			RDY9, START9, INTERRUPT9,
			ACK10, REQ10
) ;

	default
	clocking @(posedge clk);
	endclocking

	default disable iff rst;

	p1: assert property ( (~HELP1) |-> (~(RDY1 || START1 || ENDD1)) );

	p2: assert property ( ER2 |-> (not ER2[*4:$]) );

	p3: assert property ( (ER3 && RDY3) |=> (not (ER3 && RDY3)) );

	p4: assert property ( RDY4 |-> HELP4 );

	p5: assert property ( (ENDD5 || STOP5 || ER5) |=> ~RDY5 );

	p6: assert property ( (ENDD6 || STOP6 || ER6) |-> RDY6 );

	p7: assert property ( ENDD7 |-> (~START7 && ~STATUS_VALID7) );

	p8_1: assert property ( RT8 |-> ~ENABLE8 );
	p8_2: assert property ( (RT8 ##1 ~RT8) |-> (##[3:$] ENABLE8) );

	p9_1: assert property ( (RDY9 ##1 ~RDY9) implies INTERRUPT9 );
	p9_2: assert property ( (START9 ##1 ~START9) implies INTERRUPT9 );

	p10: assert property ( REQ10 |-> (##5 ACK10) );

endchecker
