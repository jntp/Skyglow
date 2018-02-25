#!/usr/bin/python3.6
import sys


def main():
  script = sys.argv[0]
  filename = sys.argv[1]

if __name__ == '__main__':
  main()



# The scat command should look like: scat -c sao -h -m 6.0 -r 18000 $ra $dec | m
# 18000 = 5 degree arcseconds... this represents the arcseconds radius
