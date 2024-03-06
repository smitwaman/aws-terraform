output "vpc_id" {
    value = aws_vpc.dpt2_vpc.id
}

output "pub_subnet1" {
    value = aws_subnet.dpt2_pub_sub1.id
}
output "pub_subnet2" {
    value = aws_subnet.dpt2_pub_sub2.id
}

output "priv_subnet" {
    value = aws_subnet.dpt2_priv_sub.id
}