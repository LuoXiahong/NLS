#include <iostream>
#include <cstdlib>
#include <fstream>
#include <string>
#include <cmath>
#include "Eigen/Dense"

#define DBL_EPSILON 2.2204460492503131e-16
using Eigen::VectorXd;

using namespace std;
int main(int argc, char* argv[])
{
  // argv[1] - input filename
  // argv[2] - output filename
  // argv[2] - P
  // argv[3] - M
  // argv[4] - lambda

  string fileName = "input", ofileName = "output";
  int  P=10,M=2000,lineCount = 0,n=0,L;
  double lambda=0.02*0.6,h,Mult,Z,dist,w;
  string line;

  switch(argc){
    case 6:
      lambda = atof(argv[5]);
    case 5:
      M = atoi(argv[4]);
    case 4:
      P = atoi(argv[3]);
    case 3:
      ofileName = argv[2];
    case 2:
      fileName = argv[1];
    default:
    break;

  }
  cout<<fileName<<endl;
  ifstream input(fileName.c_str());
  ofstream output(ofileName.c_str());
  //output.open(ofileName.c_str());
  if (input.is_open()){
    while ( getline (input,line) ){
      lineCount++;
    }
        int cnt = 0;
    input.clear();
    input.seekg(0);
    VectorXd v(lineCount+1),u = VectorXd::Zero(lineCount+1);
    while ( getline (input,line) ){
      v(n+1) = atof(line.c_str());
      n++;
    }
    input.close();
    //clock_t begin = clock();
    L = 2*P+1;
    h = 2*L*lambda*lambda;
    u.head(P+1) = v.head(P+1);
    u.tail(P) = v.tail(P);
    for(int s=P+1;s<=n-P;s++){
      Mult = 0;
      Z = 0;
      for(int t=s-M;t<=s+M;t++){
        if(t>P && t<n-P+1){
          dist = 0;
          for(int d=-P;d<P;d++){
            dist += (v(s+d)-v(t+d))*(v(s+d)-v(t+d));
          }
          w = exp(-dist/h);
          Mult+=w*v(t);
          Z+=w;
        }
      }
      u(s) = Mult/(Z+DBL_EPSILON);
    }
    //clock_t end = clock();
    //double elapsed_secs = double(end - begin) / CLOCKS_PER_SEC;
    //cout<<elapsed_secs<<" s"<<endl;
    if(output.is_open()){
        for(unsigned i=0;i<u.rows();i++){
          output<<u(i)<<'\n';
        }
        output.close();
    }
  }
  else cout << "Unable to open file";
}
