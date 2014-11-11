" Vim syntax file

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case ignore

"""""
syn match asmLocalLabel "\d\{1,2\}[:fb]"
syn match asmLabel "[a-z_][a-z0-9_]*:"he=e-1
syn match asmIdentifier "[a-z_][a-z0-9_]*"
syn match asmDirective "\.[a-z][a-z]\+"
syn match asmDirective "^[ \t]*#[a-z]\+"
syn match decNumber "0\+[1-7]\=[\t\n$,; ]"
syn match decNumber "[1-9]\d*"
syn match octNumber "0[0-7]\+"
syn match hexNumber "0[xX][0-9a-fA-F]\+"
syn match binNumber "0[bB][0-1]*"
syn region asmString start=+"+ end=+"+ skip=+\\"+ oneline
syn region asmString start=+<+ end=+>+ oneline

syn keyword cTodo TODO FIXME XXX
syn region cComment start="/\*" end="\*/" contains=cTodo fold extend
syn region asmComment start=/@/ end=/$/

"""""""""""
syn match asmOperator ":BASE:"
syn match asmOperator ":INDEX:"
syn match asmOperator ":LEN:"
syn match asmOperator ":CHR:"
syn match asmOperator ":STR:"
syn match asmOperator ":NOT:"
syn match asmOperator ":LNOT:"
syn match asmOperator ":DEF:"
syn match asmOperator ":SB_OFFSET_19_12:"
syn match asmOperator ":SB_OFFSET_11_0:"
syn match asmOperator ":MOD:"
syn match asmOperator ":LEFT:"
syn match asmOperator ":RIGHT:"
syn match asmOperator ":CC:"
syn match asmOperator ":ROL:"
syn match asmOperator ":ROR:"
syn match asmOperator ":SHL:"
syn match asmOperator ":SHR:"
syn match asmOperator ":AND:"
syn match asmOperator ":OR:"
syn match asmOperator ":EOR:"
syn match asmOperator ":LAND:"
syn match asmOperator ":LOR:"
syn match asmOperator ":LEOR:"


syn keyword asmRegister r0 r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11 r12 r13 r14 r15
syn keyword asmRegister c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15
syn keyword asmRegister p0 p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12 p13 p14 p15
syn keyword asmRegister pc lr sp ip sl sb
syn keyword asmRegister a1 a2 a3 a4 v1 v2 v3 v4 v5 v6 v7 v8
syn keyword asmRegister cpsr cpsr_c cpsr_x cpsr_s cpsr_f cpsr_cx
syn keyword asmRegister cpsr_cxs cpsr_xs cpsr_xsf cpsr_sf cpsr_cxsf
syn keyword asmRegister spsr spsr_c spsr_x spsr_s spsr_f spsr_cx
syn keyword asmRegister spsr_cxs spsr_xs spsr_xsf spsr_sf spsr_cxsf
syn keyword asmRegister f0 f1 f2 f3 f4 f5 f6 f7


syn keyword asmOpcode mov moveq movne movcs movhs movcc movlo
syn keyword asmOpcode movmi movpl movvs movvc movhi movls
syn keyword asmOpcode movge movlt movgt movle moval
syn keyword asmOpcode movs moveqs movnes movcss movhss movccs movlos
syn keyword asmOpcode movmis movpls movvss movvcs movhis movlss
syn keyword asmOpcode movges movlts movgts movles movals

syn keyword asmOpcode mvn mvneq mvnne mvncs mvnhs mvncc mvnlo
syn keyword asmOpcode mvnmi mvnpl mvnvs mvnvc mvnhi mvnls
syn keyword asmOpcode mvnge mvnlt mvngt mvnle mvnal
syn keyword asmOpcode mvns mvneqs mvnnes mvncss mvnhss mvnccs mvnlos
syn keyword asmOpcode mvnmis mvnpls mvnvss mvnvcs mvnhis mvnlss
syn keyword asmOpcode mvnges mvnlts mvngts mvnles mvnals

syn keyword asmOpcode mrs mrseq mrsne mrscs mrshs mrscc mrslo
syn keyword asmOpcode mrsmi mrspl mrsvs mrsvc mrshi mrsls
syn keyword asmOpcode mrsge mrslt mrsgt mrsle mrsal

syn keyword asmOpcode msr msreq msrne msrcs msrhs msrcc msrlo
syn keyword asmOpcode msrmi msrpl msrvs msrvc msrhi msrls
syn keyword asmOpcode msrge msrlt msrgt msrle msral

syn keyword asmOpcode mra mraeq mrane mracs mrahs mracc mralo
syn keyword asmOpcode mrami mrapl mravs mravc mrahi mrals
syn keyword asmOpcode mrage mralt mragt mrale mraal

syn keyword asmOpcode mar mareq marne marcs marhs marcc marlo
syn keyword asmOpcode marmi marpl marvs marvc marhi marls
syn keyword asmOpcode marge marlt margt marle maral

syn keyword asmOpcode add addeq addne addcs addhs addcc addlo
syn keyword asmOpcode addmi addpl addvs addvc addhi addls
syn keyword asmOpcode addge addlt addgt addle addal
syn keyword asmOpcode adds addeqs addnes addcss addhss addccs addlos
syn keyword asmOpcode addmis addpls addvss addvcs addhis addlss
syn keyword asmOpcode addges addlts addgts addles addals

syn keyword asmOpcode adc adceq adcne adccs adchs adccc adclo
syn keyword asmOpcode adcmi adcpl adcvs adcvc adchi adcls
syn keyword asmOpcode adcge adclt adcgt adcle adcal
syn keyword asmOpcode adcs adceqs adcnes adccss adchss adcccs adclos
syn keyword asmOpcode adcmis adcpls adcvss adcvcs adchis adclss
syn keyword asmOpcode adcges adclts adcgts adcles adcals

syn keyword asmOpcode qadd qaddeq qaddne qaddcs qaddhs qaddcc qaddlo
syn keyword asmOpcode qaddmi qaddpl qaddvs qaddvc qaddhi qaddls
syn keyword asmOpcode qaddge qaddlt qaddgt qaddle qaddal

syn keyword asmOpcode qdadd qdaddeq qdaddne qdaddcs qdaddhs qdaddcc
syn keyword asmOpcode qdaddlo qdaddmi qdaddpl qdaddvs qdaddvc qdaddhi
syn keyword asmOpcode qdaddls qdaddge qdaddlt qdaddgt qdaddle qdaddal

syn keyword asmOpcode sub subeq subne subcs subhs subcc sublo
syn keyword asmOpcode submi subpl subvs subvc subhi subls
syn keyword asmOpcode subge sublt subgt suble subal
syn keyword asmOpcode subs subeqs subnes subcss subhss subccs sublos
syn keyword asmOpcode submis subpls subvss subvcs subhis sublss
syn keyword asmOpcode subges sublts subgts subles subals

syn keyword asmOpcode sbc sbceq sbcne sbccs sbchs sbccc sbclo
syn keyword asmOpcode sbcmi sbcpl sbcvs sbcvc sbchi sbcls
syn keyword asmOpcode sbcge sbclt sbcgt sbcle sbcal
syn keyword asmOpcode sbcs sbceqs sbcnes sbccss sbchss sbcccs sbclos
syn keyword asmOpcode sbcmis sbcpls sbcvss sbcvcs sbchis sbclss
syn keyword asmOpcode sbcges sbclts sbcgts sbcles sbcals

syn keyword asmOpcode rsb rsbeq rsbne rsbcs rsbhs rsbcc rsblo
syn keyword asmOpcode rsbmi rsbpl rsbvs rsbvc rsbhi rsbls
syn keyword asmOpcode rsbge rsblt rsbgt rsble rsbal
syn keyword asmOpcode rsbs rsbeqs rsbnes rsbcss rsbhss rsbccs rsblos
syn keyword asmOpcode rsbmis rsbpls rsbvss rsbvcs rsbhis rsblss
syn keyword asmOpcode rsbges rsblts rsbgts rsbles rsbals

syn keyword asmOpcode rsc rsceq rscne rsccs rschs rsccc rsclo
syn keyword asmOpcode rscmi rscpl rscvs rscvc rschi rscls
syn keyword asmOpcode rscge rsclt rscgt rscle rscal
syn keyword asmOpcode rscs rsceqs rscnes rsccss rschss rscccs rsclos
syn keyword asmOpcode rscmis rscpls rscvss rscvcs rschis rsclss
syn keyword asmOpcode rscges rsclts rscgts rscles rscals

syn keyword asmOpcode qsub qsubeq qsubne qsubcs qsubhs qsubcc qsublo
syn keyword asmOpcode qsubmi qsubpl qsubvs qsubvc qsubhi qsubls
syn keyword asmOpcode qsubge qsublt qsubgt qsuble qsubal

syn keyword asmOpcode qdsub qdsubeq qdsubne qdsubcs qdsubhs qdsubcc
syn keyword asmOpcode qdsublo qdsubmi qdsubpl qdsubvs qdsubvc qdsubhi
syn keyword asmOpcode qdsubls qdsubge qdsublt qdsubgt qdsuble qdsubal

syn keyword asmOpcode mul muleq mulne mulcs mulhs mulcc mullo
syn keyword asmOpcode mulmi mulpl mulvs mulvc mulhi mulls
syn keyword asmOpcode mulge mullt mulgt mulle mulal
syn keyword asmOpcode muls muleqs mulnes mulcss mulhss mulccs mullos
syn keyword asmOpcode mulmis mulpls mulvss mulvcs mulhis mullss
syn keyword asmOpcode mulges mullts mulgts mulles mulals

syn keyword asmOpcode mla mlaeq mlane mlacs mlahs mlacc mlalo
syn keyword asmOpcode mlami mlapl mlavs mlavc mlahi mlals
syn keyword asmOpcode mlage mlalt mlagt mlale mlaal
syn keyword asmOpcode mlas mlaeqs mlanes mlacss mlahss mlaccs mlalos
syn keyword asmOpcode mlamis mlapls mlavss mlavcs mlahis mlalss
syn keyword asmOpcode mlages mlalts mlagts mlales mlaals

syn keyword asmOpcode umull umulleq umullne umullcs umullhs umullcc
syn keyword asmOpcode umulllo umullmi umullpl umullvs umullvc umullhi
syn keyword asmOpcode umullls umullge umulllt umullgt umullle umullal
syn keyword asmOpcode umulls umulleqs umullnes umullcss umullhss
syn keyword asmOpcode umullccs umulllos umullmis umullpls umullvss
syn keyword asmOpcode umullvcs umullhis umulllss umullges umulllts
syn keyword asmOpcode umullgts umullles umullals

syn keyword asmOpcode umlal umlaleq umlalne umlalcs umlalhs umlalcc
syn keyword asmOpcode umlallo umlalmi umlalpl umlalvs umlalvc umlalhi
syn keyword asmOpcode umlalls umlalge umlallt umlalgt umlalle umlalal
syn keyword asmOpcode umlals umlaleqs umlalnes umlalcss umlalhss
syn keyword asmOpcode umlalccs umlallos umlalmis umlalpls umlalvss
syn keyword asmOpcode umlalvcs umlalhis umlallss umlalges umlallts
syn keyword asmOpcode umlalgts umlalles umlalals

syn keyword asmOpcode smull smulleq smullne smullcs smullhs smullcc
syn keyword asmOpcode smulllo smullmi smullpl smullvs smullvc smullhi
syn keyword asmOpcode smullls smullge smulllt smullgt smullle smullal
syn keyword asmOpcode smulls smulleqs smullnes smullcss smullhss
syn keyword asmOpcode smullccs smulllos smullmis smullpls smullvss
syn keyword asmOpcode smullvcs smullhis smulllss smullges smulllts
syn keyword asmOpcode smullgts smullles smullals

syn keyword asmOpcode smlal smlaleq smlalne smlalcs smlalhs smlalcc
syn keyword asmOpcode smlallo smlalmi smlalpl smlalvs smlalvc smlalhi
syn keyword asmOpcode smlalls smlalge smlallt smlalgt smlalle smlalal
syn keyword asmOpcode smlals smlaleqs smlalnes smlalcss smlalhss
syn keyword asmOpcode smlalccs smlallos smlalmis smlalpls smlalvss
syn keyword asmOpcode smlalvcs smlalhis smlallss smlalges smlallts
syn keyword asmOpcode smlalgts smlalles smlalals

syn keyword asmOpcode smulxy smulxyeq smulxyne smulxycs smulxyhs
syn keyword asmOpcode smulxycc smulxylo smulxymi smulxypl smulxyvs
syn keyword asmOpcode smulxyvc smulxyhi smulxyls smulxyge smulxylt
syn keyword asmOpcode smulxygt smulxyle smulxyal

syn keyword asmOpcode smulwy smulwyeq smulwyne smulwycs smulwyhs
syn keyword asmOpcode smulwycc smulwylo smulwymi smulwypl smulwyvs
syn keyword asmOpcode smulwyvc smulwyhi smulwyls smulwyge smulwylt
syn keyword asmOpcode smulwygt smulwyle smulwyal

syn keyword asmOpcode smlaxy smlaxyeq smlaxyne smlaxycs smlaxyhs
syn keyword asmOpcode smlaxycc smlaxylo smlaxymi smlaxypl smlaxyvs
syn keyword asmOpcode smlaxyvc smlaxyhi smlaxyls smlaxyge smlaxylt
syn keyword asmOpcode smlaxygt smlaxyle smlaxyal

syn keyword asmOpcode smlawy smlawyeq smlawyne smlawycs smlawyhs
syn keyword asmOpcode smlawycc smlawylo smlawymi smlawypl smlawyvs
syn keyword asmOpcode smlawyvc smlawyhi smlawyls smlawyge smlawylt
syn keyword asmOpcode smlawygt smlawyle smlawyal

syn keyword asmOpcode smlalxy smlalxyeq smlalxyne smlalxycs smlalxyhs
syn keyword asmOpcode smlalxycc smlalxylo smlalxymi smlalxypl
syn keyword asmOpcode smlalxyvs smlalxyvc smlalxyhi smlalxyls
syn keyword asmOpcode smlalxyge smlalxylt smlalxygt smlalxyle
syn keyword asmOpcode smlalxyal

syn keyword asmOpcode mia miaeq miane miacs miahs miacc mialo
syn keyword asmOpcode miami miapl miavs miavc miahi mials
syn keyword asmOpcode miage mialt miagt miale miaal

syn keyword asmOpcode miaph miapheq miaphne miaphcs miaphhs miaphcc
syn keyword asmOpcode miaphlo miaphmi miaphpl miaphvs miaphvc miaphhi
syn keyword asmOpcode miaphls miaphge miaphlt miaphgt miaphle miaphal

syn keyword asmOpcode miaxy miaxyeq miaxyne miaxycs miaxyhs miaxycc
syn keyword asmOpcode miaxylo miaxymi miaxypl miaxyvs miaxyvc miaxyhi
syn keyword asmOpcode miaxyls miaxyge miaxylt miaxygt miaxyle miaxyal

syn keyword asmOpcode clz clzeq clzne clzcs clzhs clzcc clzlo
syn keyword asmOpcode clzmi clzpl clzvs clzvc clzhi clzls
syn keyword asmOpcode clzge clzlt clzgt clzle clzal

syn keyword asmOpcode tst tsteq tstne tstcs tsths tstcc tstlo
syn keyword asmOpcode tstmi tstpl tstvs tstvc tsthi tstls
syn keyword asmOpcode tstge tstlt tstgt tstle tstal

syn keyword asmOpcode teq teqeq teqne teqcs teqhs teqcc teqlo
syn keyword asmOpcode teqmi teqpl teqvs teqvc teqhi teqls
syn keyword asmOpcode teqge teqlt teqgt teqle teqal

syn keyword asmOpcode and andeq andne andcs andhs andcc andlo
syn keyword asmOpcode andmi andpl andvs andvc andhi andls
syn keyword asmOpcode andge andlt andgt andle andal
syn keyword asmOpcode ands andeqs andnes andcss andhss andccs andlos
syn keyword asmOpcode andmis andpls andvss andvcs andhis andlss
syn keyword asmOpcode andges andlts andgts andles andals

syn keyword asmOpcode eor eoreq eorne eorcs eorhs eorcc eorlo
syn keyword asmOpcode eormi eorpl eorvs eorvc eorhi eorls
syn keyword asmOpcode eorge eorlt eorgt eorle eoral
syn keyword asmOpcode eors eoreqs eornes eorcss eorhss eorccs eorlos
syn keyword asmOpcode eormis eorpls eorvss eorvcs eorhis eorlss
syn keyword asmOpcode eorges eorlts eorgts eorles eorals

syn keyword asmOpcode orr orreq orrne orrcs orrhs orrcc orrlo
syn keyword asmOpcode orrmi orrpl orrvs orrvc orrhi orrls
syn keyword asmOpcode orrge orrlt orrgt orrle orral
syn keyword asmOpcode orrs orreqs orrnes orrcss orrhss orrccs orrlos
syn keyword asmOpcode orrmis orrpls orrvss orrvcs orrhis orrlss
syn keyword asmOpcode orrges orrlts orrgts orrles orrals

syn keyword asmOpcode bic biceq bicne biccs bichs biccc biclo
syn keyword asmOpcode bicmi bicpl bicvs bicvc bichi bicls
syn keyword asmOpcode bicge biclt bicgt bicle bical
syn keyword asmOpcode bics biceqs bicnes biccss bichss bicccs biclos
syn keyword asmOpcode bicmis bicpls bicvss bicvcs bichis biclss
syn keyword asmOpcode bicges biclts bicgts bicles bicals

syn keyword asmOpcode cmp cmpeq cmpne cmpcs cmphs cmpcc cmplo
syn keyword asmOpcode cmpmi cmppl cmpvs cmpvc cmphi cmpls
syn keyword asmOpcode cmpge cmplt cmpgt cmple cmpal

syn keyword asmOpcode cmn cmneq cmnne cmncs cmnhs cmncc cmnlo
syn keyword asmOpcode cmnmi cmnpl cmnvs cmnvc cmnhi cmnls
syn keyword asmOpcode cmnge cmnlt cmngt cmnle cmnal

syn keyword asmOpcode nop

syn keyword asmOpcode b beq bne bcs bhs bcc blo
syn keyword asmOpcode bmi bpl bvs bvc bhi bls
syn keyword asmOpcode bge blt bgt ble bal

syn keyword asmOpcode bl bleq blne blcs blhs blcc bllo
syn keyword asmOpcode blmi blpl blvs blvc blhi blls
syn keyword asmOpcode blge bllt blgt blle blal

syn keyword asmOpcode bx bxeq bxne bxcs bxhs bxcc bxlo
syn keyword asmOpcode bxmi bxpl bxvs bxvc bxhi bxls
syn keyword asmOpcode bxge bxlt bxgt bxle bxal

syn keyword asmOpcode blx blxeq blxne blxcs blxhs blxcc blxlo
syn keyword asmOpcode blxmi blxpl blxvs blxvc blxhi blxls
syn keyword asmOpcode blxge blxlt blxgt blxle blxal

syn keyword asmOpcode ldr ldreq ldrne ldrcs ldrhs ldrcc ldrlo
syn keyword asmOpcode ldrmi ldrpl ldrvs ldrvc ldrhi ldrls
syn keyword asmOpcode ldrge ldrlt ldrgt ldrle ldral
syn keyword asmOpcode ldrt ldreqt ldrnet ldrcst ldrhst ldrcct ldrlot
syn keyword asmOpcode ldrmit ldrplt ldrvst ldrvct ldrhit ldrlst
syn keyword asmOpcode ldrget ldrltt ldrgtt ldrlet ldralt
syn keyword asmOpcode ldrb ldreqb ldrneb ldrcsb ldrhsb ldrccb ldrlob
syn keyword asmOpcode ldrmib ldrplb ldrvsb ldrvcb ldrhib ldrlsb
syn keyword asmOpcode ldrgeb ldrltb ldrgtb ldrleb ldralb
syn keyword asmOpcode ldrbt ldreqbt ldrnebt ldrcsbt ldrhsbt ldrccbt
syn keyword asmOpcode ldrlobt ldrmibt ldrplbt ldrvsbt ldrvcbt ldrhibt
syn keyword asmOpcode ldrlsbt ldrgebt ldrltbt ldrgtbt ldrlebt ldralbt
syn keyword asmOpcode ldrsb ldreqsb ldrnesb ldrcssb ldrhssb ldrccsb
syn keyword asmOpcode ldrlosb ldrmisb ldrplsb ldrvssb ldrvcsb ldrhisb
syn keyword asmOpcode ldrlssb ldrgesb ldrltsb ldrgtsb ldrlesb ldralsb
syn keyword asmOpcode ldrh ldreqh ldrneh ldrcsh ldrhsh ldrcch ldrloh
syn keyword asmOpcode ldrmih ldrplh ldrvsh ldrvch ldrhih ldrlsh
syn keyword asmOpcode ldrgeh ldrlth ldrgth ldrleh ldralh
syn keyword asmOpcode ldrsh ldreqsh ldrnesh ldrcssh ldrhssh ldrccsh
syn keyword asmOpcode ldrlosh ldrmish ldrplsh ldrvssh ldrvcsh ldrhish
syn keyword asmOpcode ldrlssh ldrgesh ldrltsh ldrgtsh ldrlesh ldralsh
syn keyword asmOpcode ldrd ldreqd ldrned ldrcsd ldrhsd ldrccd ldrlod
syn keyword asmOpcode ldrmid ldrpld ldrvsd ldrvcd ldrhid ldrlsd
syn keyword asmOpcode ldrged ldrltd ldrgtd ldrled ldrald

syn keyword asmOpcode ldmia ldmeqia ldmneia ldmcsia ldmhsia ldmccia
syn keyword asmOpcode ldmloia ldmmiia ldmplia ldmvsia ldmvcia ldmhiia
syn keyword asmOpcode ldmlsia ldmgeia ldmltia ldmgtia ldmleia ldmalia
syn keyword asmOpcode ldmib ldmeqib ldmneib ldmcsib ldmhsib ldmccib
syn keyword asmOpcode ldmloib ldmmiib ldmplib ldmvsib ldmvcib ldmhiib
syn keyword asmOpcode ldmlsib ldmgeib ldmltib ldmgtib ldmleib ldmalib
syn keyword asmOpcode ldmda ldmeqda ldmneda ldmcsda ldmhsda ldmccda
syn keyword asmOpcode ldmloda ldmmida ldmplda ldmvsda ldmvcda ldmhida
syn keyword asmOpcode ldmlsda ldmgeda ldmltda ldmgtda ldmleda ldmalda
syn keyword asmOpcode ldmdb ldmeqdb ldmnedb ldmcsdb ldmhsdb ldmccdb
syn keyword asmOpcode ldmlodb ldmmidb ldmpldb ldmvsdb ldmvcdb ldmhidb
syn keyword asmOpcode ldmlsdb ldmgedb ldmltdb ldmgtdb ldmledb ldmaldb
syn keyword asmOpcode ldmfd ldmeqfd ldmnefd ldmcsfd ldmhsfd ldmccfd
syn keyword asmOpcode ldmlofd ldmmifd ldmplfd ldmvsfd ldmvcfd ldmhifd
syn keyword asmOpcode ldmlsfd ldmgefd ldmltfd ldmgtfd ldmlefd ldmalfd
syn keyword asmOpcode ldmed ldmeqed ldmneed ldmcsed ldmhsed ldmcced
syn keyword asmOpcode ldmloed ldmmied ldmpled ldmvsed ldmvced ldmhied
syn keyword asmOpcode ldmlsed ldmgeed ldmlted ldmgted ldmleed ldmaled
syn keyword asmOpcode ldmfa ldmeqfa ldmnefa ldmcsfa ldmhsfa ldmccfa
syn keyword asmOpcode ldmlofa ldmmifa ldmplfa ldmvsfa ldmvcfa ldmhifa
syn keyword asmOpcode ldmlsfa ldmgefa ldmltfa ldmgtfa ldmlefa ldmalfa
syn keyword asmOpcode ldmea ldmeqea ldmneea ldmcsea ldmhsea ldmccea
syn keyword asmOpcode ldmloea ldmmiea ldmplea ldmvsea ldmvcea ldmhiea
syn keyword asmOpcode ldmlsea ldmgeea ldmltea ldmgtea ldmleea ldmalea

syn keyword asmOpcode pld

syn keyword asmOpcode str streq strne strcs strhs strcc strlo
syn keyword asmOpcode strmi strpl strvs strvc strhi strls
syn keyword asmOpcode strge strlt strgt strle stral
syn keyword asmOpcode strt streqt strnet strcst strhst strcct strlot
syn keyword asmOpcode strmit strplt strvst strvct strhit strlst
syn keyword asmOpcode strget strltt strgtt strlet stralt
syn keyword asmOpcode strb streqb strneb strcsb strhsb strccb strlob
syn keyword asmOpcode strmib strplb strvsb strvcb strhib strlsb
syn keyword asmOpcode strgeb strltb strgtb strleb stralb
syn keyword asmOpcode strbt streqbt strnebt strcsbt strhsbt strccbt
syn keyword asmOpcode strlobt strmibt strplbt strvsbt strvcbt strhibt
syn keyword asmOpcode strlsbt strgebt strltbt strgtbt strlebt stralbt
syn keyword asmOpcode strh streqh strneh strcsh strhsh strcch strloh
syn keyword asmOpcode strmih strplh strvsh strvch strhih strlsh
syn keyword asmOpcode strgeh strlth strgth strleh stralh
syn keyword asmOpcode strd streqd strned strcsd strhsd strccd strlod
syn keyword asmOpcode strmid strpld strvsd strvcd strhid strlsd
syn keyword asmOpcode strged strltd strgtd strled strald

syn keyword asmOpcode stmia stmeqia stmneia stmcsia stmhsia stmccia
syn keyword asmOpcode stmloia stmmiia stmplia stmvsia stmvcia stmhiia
syn keyword asmOpcode stmlsia stmgeia stmltia stmgtia stmleia stmalia
syn keyword asmOpcode stmib stmeqib stmneib stmcsib stmhsib stmccib
syn keyword asmOpcode stmloib stmmiib stmplib stmvsib stmvcib stmhiib
syn keyword asmOpcode stmlsib stmgeib stmltib stmgtib stmleib stmalib
syn keyword asmOpcode stmda stmeqda stmneda stmcsda stmhsda stmccda
syn keyword asmOpcode stmloda stmmida stmplda stmvsda stmvcda stmhida
syn keyword asmOpcode stmlsda stmgeda stmltda stmgtda stmleda stmalda
syn keyword asmOpcode stmdb stmeqdb stmnedb stmcsdb stmhsdb stmccdb
syn keyword asmOpcode stmlodb stmmidb stmpldb stmvsdb stmvcdb stmhidb
syn keyword asmOpcode stmlsdb stmgedb stmltdb stmgtdb stmledb stmaldb
syn keyword asmOpcode stmfd stmeqfd stmnefd stmcsfd stmhsfd stmccfd
syn keyword asmOpcode stmlofd stmmifd stmplfd stmvsfd stmvcfd stmhifd
syn keyword asmOpcode stmlsfd stmgefd stmltfd stmgtfd stmlefd stmalfd
syn keyword asmOpcode stmed stmeqed stmneed stmcsed stmhsed stmcced
syn keyword asmOpcode stmloed stmmied stmpled stmvsed stmvced stmhied
syn keyword asmOpcode stmlsed stmgeed stmlted stmgted stmleed stmaled
syn keyword asmOpcode stmfa stmeqfa stmnefa stmcsfa stmhsfa stmccfa
syn keyword asmOpcode stmlofa stmmifa stmplfa stmvsfa stmvcfa stmhifa
syn keyword asmOpcode stmlsfa stmgefa stmltfa stmgtfa stmlefa stmalfa
syn keyword asmOpcode stmea stmeqea stmneea stmcsea stmhsea stmccea
syn keyword asmOpcode stmloea stmmiea stmplea stmvsea stmvcea stmhiea
syn keyword asmOpcode stmlsea stmgeea stmltea stmgtea stmleea stmalea

syn keyword asmOpcode swp swpeq swpne swpcs swphs swpcc swplo
syn keyword asmOpcode swpmi swppl swpvs swpvc swphi swpls
syn keyword asmOpcode swpge swplt swpgt swple swpal

syn keyword asmOpcode swpb swpeqb swpneb swpcsb swphsb swpccb swplob 
syn keyword asmOpcode swpmib swpplb swpvsb swpvcb swphib swplsb 
syn keyword asmOpcode swpgeb swpltb swpgtb swpleb swpalb 

syn keyword asmOpcode cdp cdpeq cdpne cdpcs cdphs cdpcc cdplo
syn keyword asmOpcode cdpmi cdppl cdpvs cdpvc cdphi cdpls
syn keyword asmOpcode cdpge cdplt cdpgt cdple cdpal

syn keyword asmOpcode cdp2 cdp2eq cdp2ne cdp2cs cdp2hs cdp2cc cdp2lo
syn keyword asmOpcode cdp2mi cdp2pl cdp2vs cdp2vc cdp2hi cdp2ls
syn keyword asmOpcode cdp2ge cdp2lt cdp2gt cdp2le cdp2al

syn keyword asmOpcode mrc mrceq mrcne mrccs mrchs mrccc mrclo
syn keyword asmOpcode mrcmi mrcpl mrcvs mrcvc mrchi mrcls
syn keyword asmOpcode mrcge mrclt mrcgt mrcle mrcal

syn keyword asmOpcode mrc2 mrc2eq mrc2ne mrc2cs mrc2hs mrc2cc mrc2lo
syn keyword asmOpcode mrc2mi mrc2pl mrc2vs mrc2vc mrc2hi mrc2ls
syn keyword asmOpcode mrc2ge mrc2lt mrc2gt mrc2le mrc2al

syn keyword asmOpcode mrrc mrrceq mrrcne mrrccs mrrchs mrrccc mrrclo
syn keyword asmOpcode mrrcmi mrrcpl mrrcvs mrrcvc mrrchi mrrcls
syn keyword asmOpcode mrrcge mrrclt mrrcgt mrrcle mrrcal

syn keyword asmOpcode mcr mcreq mcrne mcrcs mcrhs mcrcc mcrlo
syn keyword asmOpcode mcrmi mcrpl mcrvs mcrvc mcrhi mcrls
syn keyword asmOpcode mcrge mcrlt mcrgt mcrle mcral

syn keyword asmOpcode mcr2 mcr2eq mcr2ne mcr2cs mcr2hs mcr2cc mcr2lo
syn keyword asmOpcode mcr2mi mcr2pl mcr2vs mcr2vc mcr2hi mcr2ls
syn keyword asmOpcode mcr2ge mcr2lt mcr2gt mcr2le mcr2al

syn keyword asmOpcode mcrr mcrreq mcrrne mcrrcs mcrrhs mcrrcc mcrrlo
syn keyword asmOpcode mcrrmi mcrrpl mcrrvs mcrrvc mcrrhi mcrrls
syn keyword asmOpcode mcrrge mcrrlt mcrrgt mcrrle mcrral

syn keyword asmOpcode ldc ldceq ldcne ldccs ldchs ldccc ldclo
syn keyword asmOpcode ldcmi ldcpl ldcvs ldcvc ldchi ldcls
syn keyword asmOpcode ldcge ldclt ldcgt ldcle ldcal

syn keyword asmOpcode ldc2 ldc2eq ldc2ne ldc2cs ldc2hs ldc2cc ldc2lo
syn keyword asmOpcode ldc2mi ldc2pl ldc2vs ldc2vc ldc2hi ldc2ls
syn keyword asmOpcode ldc2ge ldc2lt ldc2gt ldc2le ldc2al

syn keyword asmOpcode stc stceq stcne stccs stchs stccc stclo
syn keyword asmOpcode stcmi stcpl stcvs stcvc stchi stcls
syn keyword asmOpcode stcge stclt stcgt stcle stcal

syn keyword asmOpcode stc2 stc2eq stc2ne stc2cs stc2hs stc2cc stc2lo
syn keyword asmOpcode stc2mi stc2pl stc2vs stc2vc stc2hi stc2ls
syn keyword asmOpcode stc2ge stc2lt stc2gt stc2le stc2al

syn keyword asmOpcode swi swieq swine swics swihs swicc swilo
syn keyword asmOpcode swimi swipl swivs swivc swihi swils
syn keyword asmOpcode swige swilt swigt swile swial

syn keyword asmOpcode bkpt

syn keyword asmOpcode neg lsl lsr asr ror rrx push pop

syn keyword asmOpcode fmuls fmulseq fmulsne fmulscs fmulshs fmulscc
syn keyword asmOpcode fmulslo fmulsmi fmulspl fmulsvs fmulsvc fmulshi
syn keyword asmOpcode fmulsls fmulsge fmulslt fmulsgt fmulsle fmulsal
syn keyword asmOpcode fmuld fmuldeq fmuldne fmuldcs fmuldhs fmuldcc
syn keyword asmOpcode fmuldlo fmuldmi fmuldpl fmuldvs fmuldvc fmuldhi
syn keyword asmOpcode fmuldls fmuldge fmuldlt fmuldgt fmuldle fmuldal

syn keyword asmOpcode fnmuls fnmulseq fnmulsne fnmulscs fnmulshs
syn keyword asmOpcode fnmulscc fnmulslo fnmulsmi fnmulspl fnmulsvs
syn keyword asmOpcode fnmulsvc fnmulshi fnmulsls fnmulsge fnmulslt
syn keyword asmOpcode fnmulsgt fnmulsle fnmulsal fnmuld fnmuldeq
syn keyword asmOpcode fnmuldne fnmuldcs fnmuldhs fnmuldcc fnmuldlo
syn keyword asmOpcode fnmuldmi fnmuldpl fnmuldvs fnmuldvc fnmuldhi
syn keyword asmOpcode fnmuldls fnmuldge fnmuldlt fnmuldgt fnmuldle
syn keyword asmOpcode fnmuldal

syn keyword asmOpcode fmacs fmacseq fmacsne fmacscs fmacshs fmacscc
syn keyword asmOpcode fmacslo fmacsmi fmacspl fmacsvs fmacsvc fmacshi
syn keyword asmOpcode fmacsls fmacsge fmacslt fmacsgt fmacsle fmacsal
syn keyword asmOpcode fmacd fmacdeq fmacdne fmacdcs fmacdhs fmacdcc
syn keyword asmOpcode fmacdlo fmacdmi fmacdpl fmacdvs fmacdvc fmacdhi
syn keyword asmOpcode fmacdls fmacdge fmacdlt fmacdgt fmacdle fmacdal

syn keyword asmOpcode fnmacs fnmacseq fnmacsne fnmacscs fnmacshs
syn keyword asmOpcode fnmacscc fnmacslo fnmacsmi fnmacspl fnmacsvs
syn keyword asmOpcode fnmacsvc fnmacshi fnmacsls fnmacsge fnmacslt
syn keyword asmOpcode fnmacsgt fnmacsle fnmacsal fnmacd fnmacdeq
syn keyword asmOpcode fnmacdne fnmacdcs fnmacdhs fnmacdcc fnmacdlo
syn keyword asmOpcode fnmacdmi fnmacdpl fnmacdvs fnmacdvc fnmacdhi
syn keyword asmOpcode fnmacdls fnmacdge fnmacdlt fnmacdgt fnmacdle
syn keyword asmOpcode fnmacdal

syn keyword asmOpcode fmscs fmscseq fmscsne fmscscs fmscshs fmscscc
syn keyword asmOpcode fmscslo fmscsmi fmscspl fmscsvs fmscsvc fmscshi
syn keyword asmOpcode fmscsls fmscsge fmscslt fmscsgt fmscsle fmscsal
syn keyword asmOpcode fmscd fmscdeq fmscdne fmscdcs fmscdhs fmscdcc
syn keyword asmOpcode fmscdlo fmscdmi fmscdpl fmscdvs fmscdvc fmscdhi
syn keyword asmOpcode fmscdls fmscdge fmscdlt fmscdgt fmscdle fmscdal

syn keyword asmOpcode fnmscs fnmscseq fnmscsne fnmscscs fnmscshs
syn keyword asmOpcode fnmscscc fnmscslo fnmscsmi fnmscspl fnmscsvs
syn keyword asmOpcode fnmscsvc fnmscshi fnmscsls fnmscsge fnmscslt
syn keyword asmOpcode fnmscsgt fnmscsle fnmscsal fnmscd fnmscdeq
syn keyword asmOpcode fnmscdne fnmscdcs fnmscdhs fnmscdcc fnmscdlo
syn keyword asmOpcode fnmscdmi fnmscdpl fnmscdvs fnmscdvc fnmscdhi
syn keyword asmOpcode fnmscdls fnmscdge fnmscdlt fnmscdgt fnmscdle
syn keyword asmOpcode fnmscdal

syn keyword asmOpcode fadds faddseq faddsne faddscs faddshs faddscc
syn keyword asmOpcode faddslo faddsmi faddspl faddsvs faddsvc faddshi
syn keyword asmOpcode faddsls faddsge faddslt faddsgt faddsle faddsal
syn keyword asmOpcode faddd fadddeq fadddne fadddcs fadddhs fadddcc
syn keyword asmOpcode fadddlo fadddmi fadddpl fadddvs fadddvc fadddhi
syn keyword asmOpcode fadddls fadddge fadddlt fadddgt fadddle fadddal

syn keyword asmOpcode fsubs fsubseq fsubsne fsubscs fsubshs fsubscc
syn keyword asmOpcode fsubslo fsubsmi fsubspl fsubsvs fsubsvc fsubshi
syn keyword asmOpcode fsubsls fsubsge fsubslt fsubsgt fsubsle fsubsal
syn keyword asmOpcode fsubd fsubdeq fsubdne fsubdcs fsubdhs fsubdcc
syn keyword asmOpcode fsubdlo fsubdmi fsubdpl fsubdvs fsubdvc fsubdhi
syn keyword asmOpcode fsubdls fsubdge fsubdlt fsubdgt fsubdle fsubdal

syn keyword asmOpcode fdivs fdivseq fdivsne fdivscs fdivshs fdivscc
syn keyword asmOpcode fdivslo fdivsmi fdivspl fdivsvs fdivsvc fdivshi
syn keyword asmOpcode fdivsls fdivsge fdivslt fdivsgt fdivsle fdivsal
syn keyword asmOpcode fdivd fdivdeq fdivdne fdivdcs fdivdhs fdivdcc
syn keyword asmOpcode fdivdlo fdivdmi fdivdpl fdivdvs fdivdvc fdivdhi
syn keyword asmOpcode fdivdls fdivdge fdivdlt fdivdgt fdivdle fdivdal

syn keyword asmOpcode fcpys fcpyseq fcpysne fcpyscs fcpyshs fcpyscc
syn keyword asmOpcode fcpyslo fcpysmi fcpyspl fcpysvs fcpysvc fcpyshi
syn keyword asmOpcode fcpysls fcpysge fcpyslt fcpysgt fcpysle fcpysal
syn keyword asmOpcode fcpyd fcpydeq fcpydne fcpydcs fcpydhs fcpydcc
syn keyword asmOpcode fcpydlo fcpydmi fcpydpl fcpydvs fcpydvc fcpydhi
syn keyword asmOpcode fcpydls fcpydge fcpydlt fcpydgt fcpydle fcpydal

syn keyword asmOpcode fabss fabsseq fabssne fabsscs fabsshs fabsscc
syn keyword asmOpcode fabsslo fabssmi fabsspl fabssvs fabssvc fabsshi
syn keyword asmOpcode fabssls fabssge fabsslt fabssgt fabssle fabssal
syn keyword asmOpcode fabsd fabsdeq fabsdne fabsdcs fabsdhs fabsdcc
syn keyword asmOpcode fabsdlo fabsdmi fabsdpl fabsdvs fabsdvc fabsdhi
syn keyword asmOpcode fabsdls fabsdge fabsdlt fabsdgt fabsdle fabsdal

syn keyword asmOpcode fnegs fnegseq fnegsne fnegscs fnegshs fnegscc
syn keyword asmOpcode fnegslo fnegsmi fnegspl fnegsvs fnegsvc fnegshi
syn keyword asmOpcode fnegsls fnegsge fnegslt fnegsgt fnegsle fnegsal
syn keyword asmOpcode fnegd fnegdeq fnegdne fnegdcs fnegdhs fnegdcc
syn keyword asmOpcode fnegdlo fnegdmi fnegdpl fnegdvs fnegdvc fnegdhi
syn keyword asmOpcode fnegdls fnegdge fnegdlt fnegdgt fnegdle fnegdal

syn keyword asmOpcode fsqrts fsqrtseq fsqrtsne fsqrtscs fsqrtshs
syn keyword asmOpcode fsqrtscc fsqrtslo fsqrtsmi fsqrtspl fsqrtsvs
syn keyword asmOpcode fsqrtsvc fsqrtshi fsqrtsls fsqrtsge fsqrtslt
syn keyword asmOpcode fsqrtsgt fsqrtsle fsqrtsal fsqrtd fsqrtdeq
syn keyword asmOpcode fsqrtdne fsqrtdcs fsqrtdhs fsqrtdcc fsqrtdlo
syn keyword asmOpcode fsqrtdmi fsqrtdpl fsqrtdvs fsqrtdvc fsqrtdhi
syn keyword asmOpcode fsqrtdls fsqrtdge fsqrtdlt fsqrtdgt fsqrtdle
syn keyword asmOpcode fsqrtdal

syn keyword asmOpcode fcmps fcmpseq fcmpsne fcmpscs fcmpshs fcmpscc
syn keyword asmOpcode fcmpslo fcmpsmi fcmpspl fcmpsvs fcmpsvc fcmpshi
syn keyword asmOpcode fcmpsls fcmpsge fcmpslt fcmpsgt fcmpsle fcmpsal
syn keyword asmOpcode fcmpd fcmpdeq fcmpdne fcmpdcs fcmpdhs fcmpdcc
syn keyword asmOpcode fcmpdlo fcmpdmi fcmpdpl fcmpdvs fcmpdvc fcmpdhi
syn keyword asmOpcode fcmpdls fcmpdge fcmpdlt fcmpdgt fcmpdle fcmpdal

syn keyword asmOpcode fcmpes fcmpeseq fcmpesne fcmpescs fcmpeshs
syn keyword asmOpcode fcmpescc fcmpeslo fcmpesmi fcmpespl fcmpesvs
syn keyword asmOpcode fcmpesvc fcmpeshi fcmpesls fcmpesge fcmpeslt
syn keyword asmOpcode fcmpesgt fcmpesle fcmpesal fcmped fcmpedeq
syn keyword asmOpcode fcmpedne fcmpedcs fcmpedhs fcmpedcc fcmpedlo
syn keyword asmOpcode fcmpedmi fcmpedpl fcmpedvs fcmpedvc fcmpedhi
syn keyword asmOpcode fcmpedls fcmpedge fcmpedlt fcmpedgt fcmpedle
syn keyword asmOpcode fcmpedal

syn keyword asmOpcode fcmpzs fcmpzseq fcmpzsne fcmpzscs fcmpzshs
syn keyword asmOpcode fcmpzscc fcmpzslo fcmpzsmi fcmpzspl fcmpzsvs
syn keyword asmOpcode fcmpzsvc fcmpzshi fcmpzsls fcmpzsge fcmpzslt
syn keyword asmOpcode fcmpzsgt fcmpzsle fcmpzsal fcmpzd fcmpzdeq
syn keyword asmOpcode fcmpzdne fcmpzdcs fcmpzdhs fcmpzdcc fcmpzdlo
syn keyword asmOpcode fcmpzdmi fcmpzdpl fcmpzdvs fcmpzdvc fcmpzdhi
syn keyword asmOpcode fcmpzdls fcmpzdge fcmpzdlt fcmpzdgt fcmpzdle
syn keyword asmOpcode fcmpzdal

syn keyword asmOpcode fcmpezs fcmpezseq fcmpezsne fcmpezscs fcmpezshs
syn keyword asmOpcode fcmpezscc fcmpezslo fcmpezsmi fcmpezspl
syn keyword asmOpcode fcmpezsvs fcmpezsvc fcmpezshi fcmpezsls
syn keyword asmOpcode fcmpezsge fcmpezslt fcmpezsgt fcmpezsle
syn keyword asmOpcode fcmpezsal fcmpezd fcmpezdeq fcmpezdne fcmpezdcs
syn keyword asmOpcode fcmpezdhs fcmpezdcc fcmpezdlo fcmpezdmi
syn keyword asmOpcode fcmpezdpl fcmpezdvs fcmpezdvc fcmpezdhi
syn keyword asmOpcode fcmpezdls fcmpezdge fcmpezdlt fcmpezdgt
syn keyword asmOpcode fcmpezdle fcmpezdal

syn keyword asmOpcode fcvtds fcvtdseq fcvtdsne fcvtdscs fcvtdshs
syn keyword asmOpcode fcvtdscc fcvtdslo fcvtdsmi fcvtdspl fcvtdsvs
syn keyword asmOpcode fcvtdsvc fcvtdshi fcvtdsls fcvtdsge fcvtdslt
syn keyword asmOpcode fcvtdsgt fcvtdsle fcvtdsal

syn keyword asmOpcode fcvtsd fcvtsdeq fcvtsdne fcvtsdcs fcvtsdhs
syn keyword asmOpcode fcvtsdcc fcvtsdlo fcvtsdmi fcvtsdpl fcvtsdvs
syn keyword asmOpcode fcvtsdvc fcvtsdhi fcvtsdls fcvtsdge fcvtsdlt
syn keyword asmOpcode fcvtsdgt fcvtsdle fcvtsdal

syn keyword asmOpcode fuitos fuitoseq fuitosne fuitoscs fuitoshs
syn keyword asmOpcode fuitoscc fuitoslo fuitosmi fuitospl fuitosvs
syn keyword asmOpcode fuitosvc fuitoshi fuitosls fuitosge fuitoslt
syn keyword asmOpcode fuitosgt fuitosle fuitosal
syn keyword asmOpcode fuitod fuitodeq fuitodne fuitodcs fuitodhs
syn keyword asmOpcode fuitodcc fuitodlo fuitodmi fuitodpl fuitodvs
syn keyword asmOpcode fuitodvc fuitodhi fuitodls fuitodge fuitodlt
syn keyword asmOpcode fuitodgt fuitodle fuitodal

syn keyword asmOpcode fsitos fsitoseq fsitosne fsitoscs fsitoshs
syn keyword asmOpcode fsitoscc fsitoslo fsitosmi fsitospl fsitosvs
syn keyword asmOpcode fsitosvc fsitoshi fsitosls fsitosge fsitoslt
syn keyword asmOpcode fsitosgt fsitosle fsitosal
syn keyword asmOpcode fsitod fsitodeq fsitodne fsitodcs fsitodhs
syn keyword asmOpcode fsitodcc fsitodlo fsitodmi fsitodpl fsitodvs
syn keyword asmOpcode fsitodvc fsitodhi fsitodls fsitodge fsitodlt
syn keyword asmOpcode fsitodgt fsitodle fsitodal

syn keyword asmOpcode ftouis ftouiseq ftouisne ftouiscs ftouishs
syn keyword asmOpcode ftouiscc ftouislo ftouismi ftouispl ftouisvs
syn keyword asmOpcode ftouisvc ftouishi ftouisls ftouisge ftouislt
syn keyword asmOpcode ftouisgt ftouisle ftouisal
syn keyword asmOpcode ftouid ftouideq ftouidne ftouidcs ftouidhs
syn keyword asmOpcode ftouidcc ftouidlo ftouidmi ftouidpl ftouidvs
syn keyword asmOpcode ftouidvc ftouidhi ftouidls ftouidge ftouidlt
syn keyword asmOpcode ftouidgt ftouidle ftouidal

syn keyword asmOpcode ftouizs ftouizseq ftouizsne ftouizscs ftouizshs
syn keyword asmOpcode ftouizscc ftouizslo ftouizsmi ftouizspl
syn keyword asmOpcode ftouizsvs ftouizsvc ftouizshi ftouizsls
syn keyword asmOpcode ftouizsge ftouizslt ftouizsgt ftouizsle
syn keyword asmOpcode ftouizsal
syn keyword asmOpcode ftouizd ftouizdeq ftouizdne ftouizdcs ftouizdhs
syn keyword asmOpcode ftouizdcc ftouizdlo ftouizdmi ftouizdpl
syn keyword asmOpcode ftouizdvs ftouizdvc ftouizdhi ftouizdls
syn keyword asmOpcode ftouizdge ftouizdlt ftouizdgt ftouizdle
syn keyword asmOpcode ftouizdal

syn keyword asmOpcode ftosis ftosiseq ftosisne ftosiscs ftosishs
syn keyword asmOpcode ftosiscc ftosislo ftosismi ftosispl ftosisvs
syn keyword asmOpcode ftosisvc ftosishi ftosisls ftosisge ftosislt
syn keyword asmOpcode ftosisgt ftosisle ftosisal
syn keyword asmOpcode ftosid ftosideq ftosidne ftosidcs ftosidhs
syn keyword asmOpcode ftosidcc ftosidlo ftosidmi ftosidpl ftosidvs
syn keyword asmOpcode ftosidvc ftosidhi ftosidls ftosidge ftosidlt
syn keyword asmOpcode ftosidgt ftosidle ftosidal

syn keyword asmOpcode ftosizs ftosizseq ftosizsne ftosizscs ftosizshs
syn keyword asmOpcode ftosizscc ftosizslo ftosizsmi ftosizspl
syn keyword asmOpcode ftosizsvs ftosizsvc ftosizshi ftosizsls
syn keyword asmOpcode ftosizsge ftosizslt ftosizsgt ftosizsle
syn keyword asmOpcode ftosizsal
syn keyword asmOpcode ftosizd ftosizdeq ftosizdne ftosizdcs ftosizdhs
syn keyword asmOpcode ftosizdcc ftosizdlo ftosizdmi ftosizdpl
syn keyword asmOpcode ftosizdvs ftosizdvc ftosizdhi ftosizdls
syn keyword asmOpcode ftosizdge ftosizdlt ftosizdgt ftosizdle
syn keyword asmOpcode ftosizdal

syn keyword asmOpcode fsts fstseq fstsne fstscs fstshs fstscc fstslo
syn keyword asmOpcode fstsmi fstspl fstsvs fstsvc fstshi fstsls
syn keyword asmOpcode fstsge fstslt fstsgt fstsle fstsal
syn keyword asmOpcode fstd fstdeq fstdne fstdcs fstdhs fstdcc fstdlo
syn keyword asmOpcode fstdmi fstdpl fstdvs fstdvc fstdhi fstdls
syn keyword asmOpcode fstdge fstdlt fstdgt fstdle fstdal

syn keyword asmOpcode fstmias fstmiaseq fstmiasne fstmiascs fstmiashs
syn keyword asmOpcode fstmiascc fstmiaslo fstmiasmi fstmiaspl
syn keyword asmOpcode fstmiasvs fstmiasvc fstmiashi fstmiasls
syn keyword asmOpcode fstmiasge fstmiaslt fstmiasgt fstmiasle
syn keyword asmOpcode fstmiasal
syn keyword asmOpcode fstmiad fstmiadeq fstmiadne fstmiadcs fstmiadhs
syn keyword asmOpcode fstmiadcc fstmiadlo fstmiadmi fstmiadpl
syn keyword asmOpcode fstmiadvs fstmiadvc fstmiadhi fstmiadls
syn keyword asmOpcode fstmiadge fstmiadlt fstmiadgt fstmiadle
syn keyword asmOpcode fstmiadal
syn keyword asmOpcode fstmiax fstmiaxeq fstmiaxne fstmiaxcs fstmiaxhs
syn keyword asmOpcode fstmiaxcc fstmiaxlo fstmiaxmi fstmiaxpl
syn keyword asmOpcode fstmiaxvs fstmiaxvc fstmiaxhi fstmiaxls
syn keyword asmOpcode fstmiaxge fstmiaxlt fstmiaxgt fstmiaxle
syn keyword asmOpcode fstmiaxal

syn keyword asmOpcode fstmdbs fstmdbseq fstmdbsne fstmdbscs fstmdbshs
syn keyword asmOpcode fstmdbscc fstmdbslo fstmdbsmi fstmdbspl
syn keyword asmOpcode fstmdbsvs fstmdbsvc fstmdbshi fstmdbsls
syn keyword asmOpcode fstmdbsge fstmdbslt fstmdbsgt fstmdbsle
syn keyword asmOpcode fstmdbsal
syn keyword asmOpcode fstmdbd fstmdbdeq fstmdbdne fstmdbdcs fstmdbdhs
syn keyword asmOpcode fstmdbdcc fstmdbdlo fstmdbdmi fstmdbdpl
syn keyword asmOpcode fstmdbdvs fstmdbdvc fstmdbdhi fstmdbdls
syn keyword asmOpcode fstmdbdge fstmdbdlt fstmdbdgt fstmdbdle
syn keyword asmOpcode fstmdbdal
syn keyword asmOpcode fstmdbx fstmdbxeq fstmdbxne fstmdbxcs fstmdbxhs
syn keyword asmOpcode fstmdbxcc fstmdbxlo fstmdbxmi fstmdbxpl
syn keyword asmOpcode fstmdbxvs fstmdbxvc fstmdbxhi fstmdbxls
syn keyword asmOpcode fstmdbxge fstmdbxlt fstmdbxgt fstmdbxle
syn keyword asmOpcode fstmdbxal

syn keyword asmOpcode flds fldseq fldsne fldscs fldshs fldscc fldslo
syn keyword asmOpcode fldsmi fldspl fldsvs fldsvc fldshi fldsls
syn keyword asmOpcode fldsge fldslt fldsgt fldsle fldsal
syn keyword asmOpcode fldd flddeq flddne flddcs flddhs flddcc flddlo
syn keyword asmOpcode flddmi flddpl flddvs flddvc flddhi flddls
syn keyword asmOpcode flddge flddlt flddgt flddle flddal

syn keyword asmOpcode fldmias fldmiaseq fldmiasne fldmiascs fldmiashs
syn keyword asmOpcode fldmiascc fldmiaslo fldmiasmi fldmiaspl
syn keyword asmOpcode fldmiasvs fldmiasvc fldmiashi fldmiasls
syn keyword asmOpcode fldmiasge fldmiaslt fldmiasgt fldmiasle
syn keyword asmOpcode fldmiasal
syn keyword asmOpcode fldmiad fldmiadeq fldmiadne fldmiadcs fldmiadhs
syn keyword asmOpcode fldmiadcc fldmiadlo fldmiadmi fldmiadpl
syn keyword asmOpcode fldmiadvs fldmiadvc fldmiadhi fldmiadls
syn keyword asmOpcode fldmiadge fldmiadlt fldmiadgt fldmiadle
syn keyword asmOpcode fldmiadal
syn keyword asmOpcode fldmiax fldmiaxeq fldmiaxne fldmiaxcs fldmiaxhs
syn keyword asmOpcode fldmiaxcc fldmiaxlo fldmiaxmi fldmiaxpl
syn keyword asmOpcode fldmiaxvs fldmiaxvc fldmiaxhi fldmiaxls
syn keyword asmOpcode fldmiaxge fldmiaxlt fldmiaxgt fldmiaxle
syn keyword asmOpcode fldmiaxal

syn keyword asmOpcode fldmdbs fldmdbseq fldmdbsne fldmdbscs fldmdbshs
syn keyword asmOpcode fldmdbscc fldmdbslo fldmdbsmi fldmdbspl
syn keyword asmOpcode fldmdbsvs fldmdbsvc fldmdbshi fldmdbsls
syn keyword asmOpcode fldmdbsge fldmdbslt fldmdbsgt fldmdbsle
syn keyword asmOpcode fldmdbsal
syn keyword asmOpcode fldmdbd fldmdbdeq fldmdbdne fldmdbdcs fldmdbdhs
syn keyword asmOpcode fldmdbdcc fldmdbdlo fldmdbdmi fldmdbdpl
syn keyword asmOpcode fldmdbdvs fldmdbdvc fldmdbdhi fldmdbdls
syn keyword asmOpcode fldmdbdge fldmdbdlt fldmdbdgt fldmdbdle
syn keyword asmOpcode fldmdbdal
syn keyword asmOpcode fldmdbx fldmdbxeq fldmdbxne fldmdbxcs fldmdbxhs
syn keyword asmOpcode fldmdbxcc fldmdbxlo fldmdbxmi fldmdbxpl
syn keyword asmOpcode fldmdbxvs fldmdbxvc fldmdbxhi fldmdbxls
syn keyword asmOpcode fldmdbxge fldmdbxlt fldmdbxgt fldmdbxle
syn keyword asmOpcode fldmdbxal

syn keyword asmOpcode fmsr fmsreq fmsrne fmsrcs fmsrhs fmsrcc fmsrlo
syn keyword asmOpcode fmsrmi fmsrpl fmsrvs fmsrvc fmsrhi fmsrls
syn keyword asmOpcode fmsrge fmsrlt fmsrgt fmsrle fmsral

syn keyword asmOpcode fmrs fmrseq fmrsne fmrscs fmrshs fmrscc fmrslo
syn keyword asmOpcode fmrsmi fmrspl fmrsvs fmrsvc fmrshi fmrsls
syn keyword asmOpcode fmrsge fmrslt fmrsgt fmrsle fmrsal

syn keyword asmOpcode fmdlr fmdlreq fmdlrne fmdlrcs fmdlrhs fmdlrcc
syn keyword asmOpcode fmdlrlo fmdlrmi fmdlrpl fmdlrvs fmdlrvc fmdlrhi
syn keyword asmOpcode fmdlrls fmdlrge fmdlrlt fmdlrgt fmdlrle fmdlral

syn keyword asmOpcode fmrdl fmrdleq fmrdlne fmrdlcs fmrdlhs fmrdlcc
syn keyword asmOpcode fmrdllo fmrdlmi fmrdlpl fmrdlvs fmrdlvc fmrdlhi
syn keyword asmOpcode fmrdlls fmrdlge fmrdllt fmrdlgt fmrdlle fmrdlal

syn keyword asmOpcode fmdhr fmdhreq fmdhrne fmdhrcs fmdhrhs fmdhrcc
syn keyword asmOpcode fmdhrlo fmdhrmi fmdhrpl fmdhrvs fmdhrvc fmdhrhi
syn keyword asmOpcode fmdhrls fmdhrge fmdhrlt fmdhrgt fmdhrle fmdhral

syn keyword asmOpcode fmrdh fmrdheq fmrdhne fmrdhcs fmrdhhs fmrdhcc
syn keyword asmOpcode fmrdhlo fmrdhmi fmrdhpl fmrdhvs fmrdhvc fmrdhhi
syn keyword asmOpcode fmrdhls fmrdhge fmrdhlt fmrdhgt fmrdhle fmrdhal

syn keyword asmOpcode fmxr fmxreq fmxrne fmxrcs fmxrhs fmxrcc fmxrlo
syn keyword asmOpcode fmxrmi fmxrpl fmxrvs fmxrvc fmxrhi fmxrls
syn keyword asmOpcode fmxrge fmxrlt fmxrgt fmxrle fmxral

syn keyword asmOpcode fmrx fmrxeq fmrxne fmrxcs fmrxhs fmrxcc fmrxlo
syn keyword asmOpcode fmrxmi fmrxpl fmrxvs fmrxvc fmrxhi fmrxls
syn keyword asmOpcode fmrxge fmrxlt fmrxgt fmrxle fmrxal

syn keyword asmOpcode fmstat fmstateq fmstatne fmstatcs fmstaths
syn keyword asmOpcode fmstatcc fmstatlo fmstatmi fmstatpl fmstatvs
syn keyword asmOpcode fmstatvc fmstathi fmstatls fmstatge fmstatlt
syn keyword asmOpcode fmstatgt fmstatle fmstatal

syn keyword asmOpcode adr adreq adrne adrcs adrhs adrcc adrlo
syn keyword asmOpcode adrmi adrpl adrvs adrvc adrhi adrls
syn keyword asmOpcode adrge adrlt adrgt adrle adral
syn keyword asmOpcode adrl adreql adrnel adrcsl adrhsl adrccl adrlol
syn keyword asmOpcode adrmil adrpll adrvsl adrvcl adrhil adrlsl
syn keyword asmOpcode adrgel adrltl adrgtl adrlel adrall

if exists("c_minlines")
  let b:c_minlines = c_minlines
else
  if !exists("c_no_if0")
    let b:c_minlines = 50       " #if 0 constructs can be long
  else
    let b:c_minlines = 15       " mostly for () constructs
  endif
endif
if exists("c_curly_error")
  syn sync fromstart
else
  exec "syn sync ccomment cComment minlines=" . b:c_minlines
endif

if version >= 508 || !exists("did_asm_syntax_inits")
  if version < 508
    let did_cpp_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink decNumber	Constant
  HiLink decNumber	Constant
  HiLink octNumber	Constant
  HiLink hexNumber	Constant
  HiLink binNumber	Constant
  HiLink asmBuiltIn	Constant
  HiLink asmOperator	Operator
  HiLink asmComment	Comment
  HiLink cComment	Comment
  HiLink asmDirective	PreProc 
  HiLink asmOpcode	Statement
  HiLink asmRegister	Type
  HiLink asmLabel	Special 
  HiLink asmIdentifier	Identifier
  delcommand HiLink
endif

let b:current_syntax = "asm"

