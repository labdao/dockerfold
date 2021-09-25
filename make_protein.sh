echo generating fasta file
Rscript --vanilla src/initiate_run.R
echo submitting fasta file and instruction to EC2 instance
rsync -ravh --delete -e "ssh -i /Users/rindtorf/.ssh/niklas_smallmb.pem" data/interim/ ubuntu@ec2-18-219-149-2.us-east-2.compute.amazonaws.com:/home/ubuntu/colabfold/fasta
rsync -ravh --delete -e "ssh -i /Users/rindtorf/.ssh/niklas_smallmb.pem" src ubuntu@ec2-18-219-149-2.us-east-2.compute.amazonaws.com:/home/ubuntu/colabfold/
echo starting inference
ssh -i /Users/rindtorf/.ssh/niklas_smallmb.pem ubuntu@ec2-18-219-149-2.us-east-2.compute.amazonaws.com bash /home/ubuntu/colabfold/src/run_alphafold.sh
echo pulling results from EC2 instance
rsync -rav -e "ssh -i /Users/rindtorf/.ssh/niklas_smallmb.pem" ubuntu@ec2-18-219-149-2.us-east-2.compute.amazonaws.com:/home/ubuntu/colabfold/pdb_output data/processed