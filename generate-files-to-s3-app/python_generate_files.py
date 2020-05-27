import datetime
import random
import requests
import os


def generate_random_word(max_words_count_per_line):
    grab_words = requests.get(
        "http://svnweb.freebsd.org/csrg/share/dict/words?view=co&content-type=text/plain").content.decode().splitlines()
    word_content = " ".join(
        [grab_words[random.randrange(0, len(grab_words))] for i in range(0, max_words_count_per_line)])
    return word_content


def generate_random_lines(max_lines_per_file):
    value = random.randint(0, max_lines_per_file)
    return value


def produce_file(choose_filename, directory, lines_count, words_per_line):
    number_of_lines = generate_random_lines(lines_count)
    filename = choose_filename + "-" + datetime.datetime.now().strftime("%Y%m%dT%H:%M:%S")
    path = os.getcwd() + '/' + directory
    if not os.path.isdir(path):
        os.makedirs(path)
    with open(directory + "/" + filename + ".txt", 'a+') as f:
        for line in range(0, number_of_lines):
            words = generate_random_word(words_per_line)
            f.writelines(words + "\n")
            line += 1
    file_created = directory + "/" + filename
    return f, file_created
