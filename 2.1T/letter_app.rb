require "./input_functions"

# Create the label
def input_label()
    name = input_name()
    address = input_address()
    label = name + "\n" + address
end

# Get the title and name for the label
def input_name()
    title = read_string("Please enter your title: (Mr, Mrs, Ms, Miss, Dr)")
    first_name = read_string("Please enter your first name:")
    last_name = read_string("Please enter your last name:")
    name = title + " " + first_name + " " + last_name
    return name
end

# Get the address
def input_address()
    h_number = read_string("Please enter the house or unit number:")
    street = read_string("Please enter the street name:")
    suburb = read_string("Please enter the suburb:")
    postcode = read_integer_in_range("Please enter a postcode (0000 - 9999)", 0, 9999)
    address = h_number + " " + street + "\n" + suburb + " " + postcode.to_s
    return address
end

# Get the message
def input_msg()
    subj_line = read_string("Please enter your message subject line:")
    msg_content = read_string("Please enter your message content:")
    message = "RE: " + subj_line + "\n" + "\n" + msg_content
    return message
end

# Prints out the label and message
def print_label_msg(l, m)
    puts(l)
    puts(m)
end

def main()
    label = input_label()
    message = input_msg()
    print_label_msg(label, message)
end

main()
