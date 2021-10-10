onload=function() {
	var play=false;
	var ctx=document.getElementById("canvas").getContext("2d");
	var bredde=document.getElementById("canvas").width;
	var hoejde=document.getElementById("canvas").height;
	var batOph=batNedh=batNedv=batOpv=false;
	var audio = new Audio('spil/plop.wav');
	var audio1 = new Audio('spil/Applause.wav');
	var audio2 = new Audio('spil/Slap.wav');
	var audio3 = new Audio('spil/videospilsmelodivolume.wav');


	
	document.onkeydown=function(e){
		e=e||window.event;
		var tast=e.which||e.keyCode;
		if (tast==75) batOph=true;
		if (tast==77) batNedh=true;
		if (tast==65) batOpv=true;
		if (tast==90) batNedv=true;
	};
	document.onkeyup=function(e){
		e=e||window.event;
		var tast=e.which||e.keyCode;
		if (tast==75) batOph=false;
		if (tast==77) batNedh=false;
		if (tast==65) batOpv=false;
		if (tast==90) batNedv=false;
	};
	
	var bold={
		x:10,
		y:13,
		vx: 2,
		vy: 2,
		AS: 1,
		BS: 1,
		CD: 3,
		
		move: function() {
			if (bold.x>bredde-4 || bold.x<0) bold.vx=-bold.vx;
			if (bold.y>hoejde-4 || bold.y<0) bold.vy=-bold.vy;
			
			if (bold.x==bath.x && bold.y>=bath.y && bold.y<=bath.y+bath.h) {
				bold.vx=-bold.vx;
				audio2.play();
			}
			if (bold.x==batv.x && bold.y>=batv.y && bold.y<=batv.y+batv.h) {
				bold.vx=-bold.vx;
				audio2.play();
			}
		
			bold.x+=bold.vx;
			bold.y+=bold.vy;
			
			if (bold.x>bredde-4) {
				document.getElementById("Ascore").innerHTML=" "+bold.AS++;
				bold.x=10;
				bold.y=13;
				bold.vx=2;
				audio.play();
			}
			
			if (bold.x<0) {
				document.getElementById("Bscore").innerHTML=" "+bold.BS++;			
				bold.x=bredde-14;
				bold.y=13;
				bold.vx=-2;
				audio.play();
			}
			
			if (bold.AS>9) { 
				document.getElementById("Avinder").innerHTML="A har vundet";
				bold.x=180;
				bold.y=100;
				audio1.play();
			};
			
			if (bold.BS>9) {
				document.getElementById("Bvinder").innerHTML="B har vundet";	
				bold.x=220;
				bold.y=100;
				audio1.play();
			};
			
			document.getElementById("nytspil").onclick=function() {
				if (bold.CD == 0) {
					document.getElementById("Bscore").innerHTML="0";
					document.getElementById("Ascore").innerHTML="0";
					bold.AS=1;
					bold.BS=1;
					bold.x=10;
					bold.y=13;
					bold.vx=2;
					play=false;
				}
				
				else {
					bold.CD--;
					document.getElementById("count").innerHTML=" "+bold.CD;

				}
			};
			
			ctx.fillRect(bold.x,bold.y,4,4);
		}
	};
	
	var batv={
		x: 10,
		y: 100,
		h: 25,
		
		move: function() {
			if (batNedv && batv.y<hoejde-batv.h) batv.y+=5;
			if (batOpv && batv.y>0) batv.y-=5;
			ctx.fillStyle="black";
			ctx.fillRect(batv.x,batv.y,4,batv.h);
		}
		
	
	};
	
	var bath={
		x: 386,
		y: 100,
		h: 25,
		
		move: function() {
			if (batNedh && bath.y<hoejde-bath.h) bath.y+=5;
			if (batOph && bath.y>0) bath.y-=5;
			ctx.fillStyle="black";
			ctx.fillRect(bath.x,bath.y,4,bath.h);
		}
	};
	
	document.getElementById("spil").onclick=function() {
		play=!play;
		audio.play();
	};
	function animer() {
	audio3.play();
		if (play) {
			ctx.clearRect(0,0,bredde,hoejde);
			batv.move();
			bath.move();
			bold.move();
		};
	};
	
	setInterval(animer,20);
};