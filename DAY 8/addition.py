def add(a,b):
    return a+b

def subtract(a,b):
    return a-b

def multiply(a,b):
    return a*b

def divide(a,b):
    if b == 0:
        raise ValueError("Cannot divide by zero")
    return a/b

def main():
    print("1.Addition")
    print("2.Subtraction")
    print("3.Multiplication")
    print("4.Division")

    choice = input("Enter choice(1-4): ")

    num1 = float(input("Enter first number: "))
    num2 = float(input("Enter second number: "))

    if choice == '1':
        print(f"The result of addition is: {add(num1, num2)}")
    elif choice == '2':
        print(f"The result of subtraction is: {subtract(num1, num2)}")
    elif choice == '3':
        print(f"The result of multiplication is: {multiply(num1, num2)}")
    elif choice == '4':
        if num2 != 0:
            print(f"The result of division is: {divide(num1, num2)}")
        else:
            print("Error: Cannot divide by zero")
    else:
        print("Invalid choice")

if __name__ == "__main__":
    main()
'''

'''
