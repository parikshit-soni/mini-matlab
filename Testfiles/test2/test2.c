
int add(int a,int b)
{
	int c;
	c = a+b;
	return c;
}

int main()
{
	int p,n,i,d,sum,e;
	char *ab="Enter number of elements\n";
	char *de= "Enter the elements: ";
	char *ef="The sum of array is: ";
 	char *fg="\n";
	prints(ab);
	n = readi();
	sum=0;
	for(i=0;i<n;i++)
	{
		prints(de);
		e = readi();
		sum = add(sum,e);	
	}	
	prints(ef);
	printi(sum);
	prints(fg);
	return 0;
}


