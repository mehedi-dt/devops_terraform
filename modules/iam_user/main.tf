resource "aws_iam_user" "this" {
  name = var.name

  tags = {
    Name = var.name
  }
}

module "policy" {
    source = "../iam_policy"

    name        = "${var.name}-policy"
    description = "${var.name} policy"
    policy  = var.policy
}

resource "aws_iam_user_policy_attachment" "this" {
  user = aws_iam_user.this.name
  policy_arn = module.policy.arn
}

resource "aws_iam_access_key" "this" {
  count = var.access_key ? 1 : 0
  user = aws_iam_user.this.name
}