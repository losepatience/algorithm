master theorem:
T(1)=d and for n>1,T(n)=aT(n/b)+cn n is a power of b;
  if a<b, T(n)=O(n);
  if a=b, T(n)=O(nlogn);
  if a>b, T(n)=O(nlogba)
