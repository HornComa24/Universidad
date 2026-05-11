# 7. Convirtiendo cosas

# Haz un programa en Python para convertir de un número decimal a uno binario.

# Y para convertir uno binario en decimal.

#No te olvides del octal y el hexadecimal. 

def decimal_to_binary(n):
    return bin(n).replace("0b", "")

def binary_to_decimal(b):
    return int(b, 2)

def decimal_to_octal(n):
    return oct(n).replace("0o", "")

def octal_to_decimal(o):
    return int(o, 8)

def decimal_to_hexadecimal(n):
    return hex(n).replace("0x", "")

def hexadecimal_to_decimal(h):
    return int(h, 16)

# Testeo de las funciones
decimal_num = 59
print("Decimal:", decimal_num)
binary_num = decimal_to_binary(decimal_num)
print("Binary:", binary_num)
octal_num = decimal_to_octal(decimal_num)
print("Octal:", octal_num)
hexadecimal_num = decimal_to_hexadecimal(decimal_num)
print("Hexadecimal:", hexadecimal_num)

binary_num = "11101"
print("Binary:", binary_num)
decimal_num = binary_to_decimal(binary_num)
print("Decimal:", decimal_num)

octal_num = "73"
print("Octal:", octal_num)
decimal_num = octal_to_decimal(octal_num)
print("Decimal:", decimal_num)

hexadecimal_num = "3b"
print("Hexadecimal:", hexadecimal_num)
decimal_num = hexadecimal_to_decimal(hexadecimal_num)
print("Decimal:", decimal_num)