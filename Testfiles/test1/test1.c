

int main()
{
	int p[50], n,j, i, d, temp;
	char *ab="Enter number of elements\n";
	char *bc="Sorted list in ascending order:\n";
	char *cd= " ";
	char *de= "Enter the elements: ";
	char *ef="The array is: ";
	char *fg="\n";
  	prints(ab);
  	n = readi();
 
  for (i = 0; i < n; i++)
	{
		prints(de);
		p[i] = readi();
	}
	prints(ef);	
    for (i = 0; i < n; i++)
	{
		printi(p[i]);
		prints(cd);	

	}
	prints(fg);

  for (i = 0 ; i <  n - 1 ; i++)
  {
    for (j = 0 ; j < n - i - 1; j++)
    {
      if (p[j] > p[j+1]) 
      {
        temp       = p[j];
        p[j]   = p[j+1];
        p[j+1] = temp;
      }
    }
  }
 
  prints(bc);
 
  for ( i = 0 ; i < n ; i++ )
{
	     printi(p[i]);
	     prints(cd);	
}
	     prints(fg);	

 
	return 0;
}


