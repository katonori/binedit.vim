cp 0.bin.orig 0.bin
vim -c ":source test0.vim"
cp 0.bin.orig 1.bin
vim -c ":source test1.vim"

for file in *.bin
do
    diff ${file} ref/${file}
    if [ $? -ne 0 ]; then
        exit 1
    fi
done
