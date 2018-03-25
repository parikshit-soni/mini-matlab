
int min(int a,int b)
{
	int c;
	if(a<b)
	{
		c = a;
	}
	else
	{
		c = b;
	}	
	
	return c;
}


int max(int a,int b)
{
	int c;
	if(a>b)
	{
		c =a;
		
	}
	else
	{
		c=b;
	}
	return c;
}
/*adding minimum number of two*/

int main()
{
	int p[50], n,j, a,b, suma,sumb;
	char *ab="max of a and b = ";
	char *ab2= "min of a and b = ";	
	char *cd= " ";
	char *de= "Enter the element a: ";
	char *fg="\n";
	char *gh ="Enter the element b: ";
	  	
	prints(de);
  	a = readi();
	prints(gh);
	b = readi();
	suma = max(a,b);
	sumb = min(a,b);
	prints(ab);
	printi(suma);
	prints(fg);
	prints(ab2);
	printi(sumb);
	prints(fg);
		
	return 0;
}


