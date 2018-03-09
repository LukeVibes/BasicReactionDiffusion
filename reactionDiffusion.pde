PixelData[][] ogMatrix;
PixelData[][] newMatrix;

//Diffusion Rate Formula values
float timeBetween = 1.09;
float diffRateA = 1;
float diffRateB = 0.5;
float feedRate = 0.065;
float killRate = 0.063;

//Formula for large blobs
/*
float timeBetween = 1.09;
float diffRateA = 1;
float diffRateB = 0.5;
float feedRate = 0.065;
float killRate = 0.063;

regular matrix
no pluse

*/


void setup(){
  //Window setup
  size(300, 300);
  //background(#838EF0);
  
  //Intialize Matrices
  ogMatrix  = new PixelData[width][height];
  newMatrix = new PixelData[width][height];

  for(int y=0; y < height; y++){
    for(int x=0; x < width; x++){
      ogMatrix[x][y] = new PixelData();
      newMatrix[x][y] = new PixelData();
      
      ogMatrix[x][y].a=1;
      newMatrix[x][y].a=1;     
     }
  }
  
  //Inject b chemical
  int count = 1;
  while(count < 15){
  int randX = (int) random(6, width-6);
  int randY = (int) random(6, height-6);
  
  for(int y = randY-5; y < randY+5; y++){
    for(int x= randX-5; x < randX+5; x++){
      ogMatrix[x][y] = new PixelData();
      newMatrix[x][y] = new PixelData();
      
      ogMatrix[x][y].a=1;
      ogMatrix[x][y].b=1;
      newMatrix[x][y].a=1;
      newMatrix[x][y].b=1;     
     }
   }
   count++;
  }
  
  frameRate(100);
}
  
  
  


void draw(){
  println(frameRate);
  background(#838EF0);
  
  
  
  for(int y=1; y < height-1; y++){
    for(int x=1; x < width-1; x++){
       //Changes for new Matrix
       float a = ogMatrix[x][y].a;
       float b = ogMatrix[x][y].b;
       newMatrix[x][y].a = a + (diffRateA * lapsA(x,y) - a * pow(b, 2) + feedRate * (1 - a)) * timeBetween; 
       newMatrix[x][y].b = b + (diffRateB * lapsB(x,y) + a * pow(b, 2) - (killRate + feedRate) * b) * timeBetween;  

    }
  }
  swap();
    
  //pixelDensity(1); //Done to avoid Apple Retina problems
  loadPixels();
  for(int y=1; y < height-1; y++){
    for(int x=1; x < width-1; x++){
       //Changing actual pixel
       int index = getIndex(x,y);
       pixels[index] = color((newMatrix[x][y].a-newMatrix[x][y].b)*255);
    }
  }
  updatePixels();
  /*
  feedRate = constrain(feedRate - 0.00002, 0.042, 0.058);
  if(feedRate == 0.042){
    feedRate = 0.057;
  }
  */
}


//Decr: used to get index for pixel array
int getIndex(int x, int y){
  int index;
  int cleanX = x;
  int cleanY = y;
  //if(x==0){cleanX = 1;}
  //if(y==0){cleanY = 1;}
  index = cleanX+cleanY*width; 

  return index;
} 


void swap() {
  PixelData[][] temp = ogMatrix;
  ogMatrix = newMatrix;
  newMatrix = temp;
}


//Desrc: used to calculate Laplacian A
float lapsA(int x, int y){
  float laps = 0;
  
      //duplicate nearby value in beyond-edge convulutions
      int myX = x; 
      int myY = y;
      
      //Perform convolution
      int i = -1;
      while(i<2){
        laps += ogMatrix[myX+i][myY].a*0.2;
        laps += ogMatrix[myX][myY+i].a*0.2;
        laps += ogMatrix[myX+i][myY+i].a*0.05;
        laps += ogMatrix[myX-i][myY+i].a*0.05;
        i = i + 2;
        //System.out.println("while loop: " + i);
      }
      laps += ogMatrix[x][y].a*-1;
  
  return laps;
}


float lapsB(int x, int y){
  float laps = 0;
      //duplicate nearby value in beyond-edge convulutions
      int myX = x; 
      int myY = y;
      
      //Perform convolution
      int i = -1;
      while(i<2){
        laps += ogMatrix[myX+i][myY].b*0.2;
        laps += ogMatrix[myX][myY+i].b*0.2;
        laps += ogMatrix[myX+i][myY+i].b*0.05;
        laps += ogMatrix[myX-i][myY+i].b*0.05;
        i = i + 2;
      }
      laps += ogMatrix[x][y].b*-1;
  
  return laps;
}