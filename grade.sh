CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

if [[ -f student-submission/ListExamples.java ]]
then
    echo "ListExamples.java file found."
else 
    echo "ListExamples.java file not found."
    echo "Grade: 0"
    exit
fi

# Step 3: Put all relevant files into the grading-area directory
cp TestListExamples.java student-submission/ListExamples.java grading-area
cp -r lib grading-area

# Step 4: Compile the java file and check that they compiled successfully
cd grading-area
javac -cp $CPATH *.java

if [[ $? -eq 0 ]]
then
    echo "The exit code for the compile step is 0."
else    
    echo "The code did not compile successfully."
    echo "Grade: 0"
    exit
fi

# Step 5: Run the tests and report the grade based on the test results.
java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > JUnitOutput.txt

if [[ $(grep "OK" JUnitOutput.txt | wc -l) -eq 1 ]]
then
    echo "Test Passed! Grade: 100%"
else
    string=$(grep "Tests run" JUnitOutput.txt)
    first_part=$(echo $string | cut -d ',' -f 1 | cut -d ' ' -f 3)
    second_part=$(echo $string | cut -d ',' -f 2 | cut -d ' ' -f 3)
    
    score=$(( $second_part * 100 / $first_part ))

    echo "Grade: $score%"

fi
