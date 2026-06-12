data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lab01_ssm_role" {
  name               = "lab01-ssm-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Name = "lab01-ssm-role"
  }
}

resource "aws_iam_role_policy_attachment" "lab01_ssm_core" {
  role       = aws_iam_role.lab01_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "lab01_ssm_instance_profile" {
  name = "lab01-ssm-instance-profile"
  role = aws_iam_role.lab01_ssm_role.name
}

resource "aws_ssm_patch_baseline" "security_baseline" {
  name             = "lab01-linux-security-baseline"
  operating_system = "AMAZON_LINUX_2"
  description      = "Baseline for security and bugfix patches"

  approval_rule {
    approve_after_days = 0
    compliance_level   = "CRITICAL"

    patch_filter {
      key    = "CLASSIFICATION"
      values = ["Security", "Bugfix"]
    }
  }

  tags = {
    Name = "lab01-security-baseline"
  }
}

resource "aws_ssm_patch_group" "lab01_patch_group" {
  baseline_id = aws_ssm_patch_baseline.security_baseline.id
  patch_group = "lab01-linux-patch-group"
}

resource "aws_ssm_association" "apply_patches" {
  name             = "AWS-RunPatchBaseline"
  association_name = "lab01-weekly-patching"

  targets {
    key    = "tag:Patch Group"
    values = [aws_ssm_patch_group.lab01_patch_group.patch_group]
  }

  schedule_expression = "cron(0 3 ? * SUN *)"

  parameters = {
    Operation    = "Install"
    RebootOption = "RebootIfNeeded"
  }

  depends_on = [aws_ssm_patch_group.lab01_patch_group]
}
