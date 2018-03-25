
int multiply(int a)
{
	a = a*2;
	return a;
}

/*This computes a* 2^a*/
int main()
{
	int p[50], n,j, a,b, suma,sumb;
	char *ab="suma = ";
	char *ab2= "sumb = ";	
	char *cd= " ";
	char *de= "Enter the element a: ";
	char *fg="\n";
	char *gh ="Enter the element b: ";
	  	
	prints(de);
  	a = readi();
	prints(gh);
	b = readi();
	suma = a;
	sumb = b;
 	while(a>0 || b>0)
	{
	    if(a<b)
		{
			sumb = multiply(sumb);
			b = b-1;
			
		}	
	     else
		{
			suma = multiply(suma);
			a = a-1;
		}	
	}
	prints(ab);
	printi(suma);
	prints(fg);
	prints(ab2);
	printi(sumb);
	prints(fg);
		
	return 0;
}


