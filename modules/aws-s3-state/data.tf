data "aws_iam_policy_document" "block_root_state" {
  statement {
    sid = "BlockRootState"

    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.tf_state.arn}/terraform.tfstate",
    ]
  }
}
