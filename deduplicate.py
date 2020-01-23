import os
import argparse


def main():
    parser = argparse.ArgumentParser("play.py")
    parser.add_argument('type', metavar='type', type=str,
                            help='type of keys to deduplicate', choices=["title", "prod"])
    args = parser.parse_args()

    exec_path = os.path.dirname(os.path.abspath(__file__))
    keys_path = f"{exec_path}/{args.type}.keys"
    new_keys_path = f"{exec_path}/{args.type}.keys.txt"

    split_str = " = " if args.type == "prod" else "="

    keys_f = open(keys_path, "r")
    key_lines = keys_f.readlines()
    keys_f.close()

    keys_f = open(new_keys_path, "r")
    new_key_lines = keys_f.readlines()
    keys_f.close()

    for new_line in new_key_lines:
      if new_line not in key_lines:
        val = new_line.split(split_str)
        bAdd = True
        for line in key_lines:
            if line.startswith(val[0]):
                bAdd = False
                key_lines.remove(line)
                key_lines.append(new_line)
                break
        if bAdd:
            key_lines.append(new_line)

    key_lines.sort()

    keys_f = open(keys_path, "w")
    keys_f.writelines(key_lines)
    keys_f.close()


if __name__ == "__main__":
    main()