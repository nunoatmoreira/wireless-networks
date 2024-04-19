clc
clear all

NETWORK = network;

NODE_LIST = node(1, 1, 1);
NODE_LIST = [NODE_LIST node(2, 3, 5)];

[NETWORK, NODE_LIST] = NETWORK.genTxPackets(NODE_LIST,1)

NETWORK = NETWORK.rxPacket(NODE_LIST,1)