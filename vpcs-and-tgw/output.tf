output "Tunnel1" {
    value = {
        avx_connection_name = "Tunnel1"
        avx_remote_bgp_as_number = var.amazon_side_asn
        avx_remote_gateway_ip = "${aws_vpn_connection.primary.tunnel1_address},${aws_vpn_connection.secondary.tunnel1_address}"
        avx_pre_shared_key = var.tunnel1_preshared_key
        avx_local_tunnel_ip = "${aws_vpn_connection.primary.tunnel1_cgw_inside_address}/30,${aws_vpn_connection.secondary.tunnel1_cgw_inside_address}/30"
        avx_remote_tunnel_ip = "${aws_vpn_connection.primary.tunnel1_vgw_inside_address}/30,${aws_vpn_connection.secondary.tunnel1_vgw_inside_address}/30"
    }
}

output "Tunnel2" {
    value = {
        avx_connection_name = "Tunnel2"
        avx_remote_bgp_as_number = var.amazon_side_asn
        avx_remote_gateway_ip = "${aws_vpn_connection.primary.tunnel2_address},${aws_vpn_connection.secondary.tunnel2_address}"
        avx_pre_shared_key = var.tunnel2_preshared_key
        avx_local_tunnel_ip = "${aws_vpn_connection.primary.tunnel2_cgw_inside_address}/30,${aws_vpn_connection.secondary.tunnel2_cgw_inside_address}/30"
        avx_remote_tunnel_ip = "${aws_vpn_connection.primary.tunnel2_vgw_inside_address}/30,${aws_vpn_connection.secondary.tunnel2_vgw_inside_address}/30"
    }
}