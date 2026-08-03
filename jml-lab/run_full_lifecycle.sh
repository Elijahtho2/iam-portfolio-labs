
#!/bin/bash
LOG=~/iam-portfolio-labs/jml-lab/jml-automation.log

# Ensure a valid Kerberos ticket exists before starting
if ! klist -s; then
  echo "No valid Kerberos ticket -- run 'kinit admin' first." >&2
  exit 1
fi

echo "=== JML full lifecycle run: $(date -Iseconds) ===" >> $LOG

echo "[$(date -Iseconds)] Starting JOINER" >> $LOG
ansible-playbook ~/iam-portfolio-labs/jml-lab/playbooks/phase1_joiner.yml \
  --vault-password-file ~/.vault_pass >> $LOG 2>&1
if [ $? -ne 0 ]; then
  echo "[$(date -Iseconds)] JOINER FAILED -- aborting" >> $LOG
  echo "JOINER failed. Check $LOG for details." >&2
  exit 1
fi
echo "[$(date -Iseconds)] JOINER complete" >> $LOG

echo "[$(date -Iseconds)] Starting MOVER" >> $LOG
ansible-playbook ~/iam-portfolio-labs/jml-lab/playbooks/phase2_mover.yml >> $LOG 2>&1
if [ $? -ne 0 ]; then
  echo "[$(date -Iseconds)] MOVER FAILED -- aborting" >> $LOG
  echo "MOVER failed. Check $LOG for details." >&2
  exit 1
fi
echo "[$(date -Iseconds)] MOVER complete" >> $LOG

echo "[$(date -Iseconds)] Starting LEAVER" >> $LOG
ansible-playbook ~/iam-portfolio-labs/jml-lab/playbooks/phase3_leaver.yml >> $LOG 2>&1
if [ $? -ne 0 ]; then
  echo "[$(date -Iseconds)] LEAVER FAILED -- aborting" >> $LOG
  echo "LEAVER failed. Check $LOG for details." >&2
  exit 1
fi
echo "[$(date -Iseconds)] LEAVER complete - full lifecycle done" >> $LOG

echo "All three phases completed successfully."
