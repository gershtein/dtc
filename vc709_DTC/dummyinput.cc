#include <stdio.h>
#include <stdlib.h>

unsigned int setbits(unsigned int u, int b, int l, int n)
{
  unsigned int c = (1<<l)-1;
  unsigned int m = n & c;
  
  m = m<<b;
  c = c<<b;

  u = u & (~c);
  u = u | m;

  return u;

}

int main()
{

  unsigned int OFF[12],PHI[12],B[12],TMUX_OFF[12];

  unsigned int S[6][40][12];
  int          N[6][40];


  for(int i=0; i<6; ++i)
    for(int j=0; j<40; ++j)
      N[i][j] = 0;

  for(int module = 0; module <3; ++module){
  
    char ss[128];
    sprintf(ss,"dummyinput_m%i.dat",module);
    FILE *fhex = fopen(ss,"w");
    sprintf(ss,"dummystubs_m%i.dat",module);
    FILE *fstubin = fopen(ss,"w");


  for(int BX=0; BX<30; ++BX){
    unsigned int u=0;

    int Nstub = rand()%12;
    Nstub++;

    for(int i=0; i<12; ++i){
      if(i<Nstub){
	OFF[i]  = rand()%8;
	TMUX_OFF[i] = (BX*8+OFF[i])/6; 
	B[i]    = (BX*8+OFF[i])%6;

	u = setbits(0,29,3,B[i]);
	u = setbits(u,0,3,i);
	u = setbits(u,3,3,TMUX_OFF[i]);
	u = setbits(u,6,2,module);
	PHI[i] = u & 255;

	int ii = B[i];
	int jj = TMUX_OFF[i];
	S[ii][jj][N[ii][jj]] = u;
	N[ii][jj] = N[ii][jj]+1;
	// printf("****************   %i    %i : %i\n",ii,jj,N[ii][jj]);
	B[i] = B[i]*2;
        
	u = setbits(0,4,8,u);
        u = setbits(u,15,3,OFF[i]);
	u = setbits(u,0,4,B[i]);
	fprintf(fstubin,"0x%08X\n",u);
      }
      else{
	OFF[i] = 0;
        TMUX_OFF[i] = 0;
	B[i] = 0;
	PHI[i] = 0;
      }
    }
    fprintf(fstubin,"\n");

    //cycle 1
    u = setbits(0,10,12,BX);
    u = setbits(u,6,4,Nstub);
    u = setbits(u,3,3,OFF[0]);
    // printf("   %d\t%d\t%d\n",BX,Nstub,OFF[0]);
    fprintf(fhex,"0x%08X\n",u);

    //cycle 2
    u = setbits(0,24,8,PHI[0]);
    u = setbits(u,20,4,B[0]);
    u = setbits(u,17,3,OFF[1]);
    u = setbits(u,6,8,PHI[1]);
    u = setbits(u,2,4,B[1]);
    u = setbits(u,0,2,OFF[2]/2);
    // printf("   %d\t%d\t%d\n",PHI[0],B[0],OFF[1]);
    // printf("   %d\t%d\t%d\n",PHI[1],B[1],OFF[2]);
    fprintf(fhex,"0x%08X\n",u);

    //cycle 3
    u = setbits(0,31,1,OFF[2]);
    u = setbits(u,20,8,PHI[2]);
    u = setbits(u,16,4,  B[2]);
    u = setbits(u,13,3,OFF[3]);
    u = setbits(u,2,8, PHI[3]);
    u = setbits(u,0,2,   B[3]/4);
    // printf("   %d\t%d\t%d\n",OFF[2],PHI[2],B[2]);
    // printf("   %d\t%d\t%d\n",OFF[3],PHI[3],B[3]);
    fprintf(fhex,"0x%08X\n",u);

    //cycle 4
    u = setbits(0,30,2,  B[3]);
    u = setbits(u,27,3,OFF[4]);
    u = setbits(u,16,8,PHI[4]);
    u = setbits(u,12,4,  B[4]);
    u = setbits(u, 9,3,OFF[5]);
    u = setbits(u, 0,6,PHI[5]/4);
    fprintf(fhex,"0x%08X\n",u);

    //cycle 5
    u = setbits(0,30,2,PHI[5]);
    u = setbits(u,26,4,  B[5]);
    u = setbits(u,23,3,OFF[6]);
    u = setbits(u,12,8,PHI[6]);
    u = setbits(u, 8,4,  B[6]);
    u = setbits(u, 5,3,OFF[7]);
    u = setbits(u, 0,2,PHI[7]/64);
    fprintf(fhex,"0x%08X\n",u);

    //cycle 6
    u = setbits(0,26,6,PHI[7]);
    u = setbits(u,22,4,  B[7]);
    u = setbits(u,19,3,OFF[8]);
    u = setbits(u, 8,8,PHI[8]);
    u = setbits(u, 4,4,  B[8]);
    u = setbits(u, 1,3,OFF[9]);
    fprintf(fhex,"0x%08X\n",u);

    //cycle 7
    u = setbits(0,22,8,PHI[9]);
    u = setbits(u,18,4,  B[9]);
    u = setbits(u,15,3,OFF[10]);
    u = setbits(u, 4,8,PHI[10]);
    u = setbits(u, 0,4,  B[10]);
    fprintf(fhex,"0x%08X\n",u);

    //cycle 8
    u = setbits(0,29,3,OFF[11]);
    u = setbits(u,18,8,PHI[11]);
    u = setbits(u,14,4,  B[11]);
    fprintf(fhex,"0x%08X\n\n",u);
  }


  }
  FILE *fres = fopen("dummyout.dat","w");

  int nnn = 0;
  for(int j=0; j<40; ++j){
    for(int i = 0; i<12; ++i){
      unsigned int b0 = S[0][j][i];
      unsigned int b1 = S[1][j][i];
      unsigned int b2 = S[2][j][i];
      unsigned int b3 = S[3][j][i];
      unsigned int b4 = S[4][j][i];
      unsigned int b5 = S[5][j][i];
      nnn = nnn + 6;
      if(i>= N[0][j]) {b0 = 0; nnn--;}
      if(i>= N[1][j]) {b1 = 0; nnn--;}
      if(i>= N[2][j]) {b2 = 0; nnn--;}
      if(i>= N[3][j]) {b3 = 0; nnn--;}
      if(i>= N[4][j]) {b4 = 0; nnn--;}
      if(i>= N[5][j]) {b5 = 0; nnn--;}
      fprintf(fres,"0x%08X \t0x%08X \t0x%08X \t0x%08X \t0x%08X \t0x%08X \n",b0,b1,b2,b3,b4,b5);
    }
    fprintf(fres,"\n");
  }
  printf("total %i\n",nnn);

}
