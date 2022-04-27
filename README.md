# CS4168-Programming-Language-Technology
 
To run parser using the run bash script:
```
$   ./run.sh
```

If run.sh does not have permission to run:
```
$    chmod +x ./run.sh
```

If error such as this appears "./run.sh: line 3: $'\r': command not found", run the following command:
```
$    sed -i 's/\r$//' run.sh
```

To remove files being generated run the clean bash script:
```
$    ./clean.sh
```

Change the contents of the test.jibuc file to find syntax warnings/errors.