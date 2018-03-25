int add(int a,int b)
{
	int c;
	c = a+b;
	return c;
}


int sub(int a,int b)
{
	int c;
	c = a-b;
	return c;
}

int mult(int a,int b)
{
	int c;
	c = a*b;
	return c;
}
int div(int a,int b)
{
	int c;
	c = a/b;
	return c;
}
int mod(int a,int b)
{
	int c;
	c = a%b;
	return c;
}
int main()
{
	int n,a,b,ans;
	char *ab="\nEnter 1 to add \n 2 to subtract\n 3 to multiply \n 4 to divide \n 5 for modulo \n 6 for exit\n";
	char *bc="The value of Computation is : ";

	char *de= "Enter the element a: ";
	char *ef="Enter the element b: ";
	char *fg="\n";
  	prints(ab);
  	n = readi();
 	while(n>=1 && n<=5)
	{	prints(de);
		a = readi();
		prints(ef);
		b = readi();
		if(n == 1)
		{
			ans = add(a,b);
		}
		else if (n==2)
		{
			ans = sub(a,b);
		}
		else if (n==3)
		{
			ans = mult(a,b);
		}
		else if(n == 4)
		{
			ans = div(a,b);
		}
		else if(n == 5)
		{
			ans = mod(a,b);
		}
		prints(fg);
		prints(bc);
		printi(ans);
		prints(fg);
		prints(fg);
		prints(ab);
		n = readi();
	}
	return 0;
}


