onload=function(){
	var bredde=document.getElementById("canvas").width;
	var hoejde=document.getElementById("canvas").height;
	var ctx = document.getElementById("canvas").getContext("2d");
	var n=rnd(50,100)
	
	function rnd(m,n){return Math.floor(Math.random()*(n-m+1))+m;};
	
	function Skive(x,y,r,vx,vy,color){
		this.x=x;
		this.y=y;
		this.r=r;
		this.vx=vy;
		this.vy=vy;
		this.color=color;
	};
	
	Skive.prototype.tegn=function(){
		ctx.beginPath();
			ctx.arc(this.x,this.y,this.r,0,2*Math.PI,true);
			ctx.fillStyle = this.color;		
			ctx.fill();
		ctx.closePath();
		
		if (this.x>bredde || this.x<0) { 
		this.vx=-this.vx;
		this.color = "rgb("+rnd(10,255)+","+rnd(10,255)+","+rnd(10,255)+")";
		};
		
		if (this.y>hoejde || this.y<0) {
		this.vy=-this.vy;
		this.color = "rgb("+rnd(10,255)+","+rnd(10,255)+","+rnd(10,255)+")";
		};
		
		if (bredde-623<this.x && this.x<bredde-622 ) { 
		this.color = "rgb("+rnd(10,255)+","+rnd(10,255)+","+rnd(10,255)+")";
		};
		
		if (this.r == this.r) {
		this.x+=this.vx;
		this.y+=this.vy;
		}
		
		this.x+=this.vx;
		this.y+=this.vy;
	};
	
	var skiver=[i];
	for (var i=0; i<n; i++) { 
		var a=rnd(0,1)
		 var b=rnd(0,1)
		
		if (a==0) {
		  a=-1;
		}
		
		if (b==0) {
		  b=-1;
		}
		
		skiver[i] = new Skive(rnd(0,bredde),rnd(0,hoejde),rnd(1,20),rnd(1,20)/5*b,rnd(1,20)/5*a,"rgb("+rnd(10,255)+","+rnd(10,255)+","+rnd(10,255)+")");
	};
	
	function animer() {
	ctx.clearRect(0,0,bredde,hoejde);
	for (var i=0; i<n; i++) skiver[i].tegn();
	};
	
	setInterval(animer,1);
}
