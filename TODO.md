* Figure out the `-detailed-exitcode` issue in branch `debug`.
    * When run on a GitHub Actions VM, `terraform plan` exits with code 0
      (instead of something different), even if there're necessary changes and
      `-detailed-exitcode` was specified. This is potentially a huge bug and
      needs to be investigated & fixed. I cannot reproduce it locally - it
      works as intended on my machine, even though the Terraform version is the
      same as on the GitHub Actions VM.
