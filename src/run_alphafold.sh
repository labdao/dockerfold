cd /home/ubuntu/colabfold
for filename in /home/ubuntu/colabfold/fasta/*.fasta; do
    [ -e "$filename" ] || continue
    var=$(basename $filename .fasta)
    echo $var
    echo $filename
    /home/ubuntu/colabfold/colabfold-conda/bin/python3.7 /home/ubuntu/colabfold/runner_af2advanced.py \
    --input $filename \
    --output_dir /home/ubuntu/colabfold/pdb/$var \
    --max_recycle 25 \
    --use_turbo 
done