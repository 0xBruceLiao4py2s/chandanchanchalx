// Written in the D programming language.

module wrapper.sodium.crypto_stream;

import wrapper.sodium.core; // assure sodium got initialized

public
import  deimos.sodium.crypto_stream;


alias crypto_stream_xor = deimos.sodium.crypto_stream.crypto_stream_xor;

/* overloaded functions */


int crypto_stream_xor(scope ubyte[] ciphertext, in ubyte[] message, in ubyte[crypto_stream_NONCEBYTES] nonce, in ubyte[crypto_stream_KEYBYTES] key) pure @trusted
{
  import std.exception : enforce;
  static import deimos.sodium.crypto_stream;
  enforce(ciphertext.length>=message.length, "ciphertext.length<message.length");
//  if (ciphertext.length<message.length /*|| nonce.length!=crypto_stream_NONCEBYTES || key.length!=crypto_stream_KEYBYTES*/)
//    throw new Exception("Error in arguments of crypto_stream_xor");
  return  deimos.sodium.crypto_stream.crypto_stream_xor(ciphertext.ptr, message.ptr, message.length, nonce.ptr, key.ptr);
}


pure @system
unittest
{
  import std.stdio : writeln, writefln;
  import std.algorithm.comparison : equal;
  import std.string : fromStringz; // @system
  debug  writeln("unittest block 1 from sodium.crypto_stream.d");

//crypto_stream_keybytes
  assert(crypto_stream_keybytes()   == crypto_stream_KEYBYTES);

//crypto_stream_noncebytes
  assert(crypto_stream_noncebytes() == crypto_stream_NONCEBYTES);

//crypto_stream_primitive
  assert(equal(fromStringz(crypto_stream_primitive()), crypto_stream_PRIMITIVE));

// from test/default/stream3.c and test/default/stream4.c :
  ubyte[32] firstkey
    = [ 0x1b, 0x27, 0x55, 0x64, 0x73, 0xe9, 0x85, 0xd4, 0x62, 0xcd, 0x51,
        0x19, 0x7a, 0x9a, 0x46, 0xc7, 0x60, 0x09, 0x54, 0x9e, 0xac, 0x64,
        0x74, 0xf2, 0x06, 0xc4, 0xee, 0x08, 0x44, 0xf6, 0x83, 0x89 ];

  ubyte[24] nonce
    = [ 0x69, 0x69, 0x6e, 0xe9, 0x55, 0xb6, 0x2b, 0x73,
        0xcd, 0x62, 0xbd, 0xa8, 0x75, 0xfc, 0x73, 0xd6,
        0x82, 0x19, 0xe0, 0x03, 0x6b, 0x7a, 0x0b, 0x37 ];

  ubyte[32] rs;

  crypto_stream(rs.ptr, rs.length, nonce.ptr, firstkey.ptr);
//  writefln("%(0x%02x,%)", rs);
  assert(rs == [0xee,0xa6,0xa7,0x25,0x1c,0x1e,0x72,0x91,0x6d,0x11,0xc2,0xcb,0x21,0x4d,0x3c,0x25,0x25,0x39,0x12,0x1d,0x8e,0x23,0x4e,0x65,0x2d,0x65,0x1f,0xa4,0xc8,0xcf,0xf8,0x80]);

  ubyte[163] m
    = [ 0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
        0,    0,    0,    0,    0,    0,    0,    0,    0xbe, 0x07, 0x5f, 0xc5,
        0x3c, 0x81, 0xf2, 0xd5, 0xcf, 0x14, 0x13, 0x16, 0xeb, 0xeb, 0x0c, 0x7b,
        0x52, 0x28, 0xc5, 0x2a, 0x4c, 0x62, 0xcb, 0xd4, 0x4b, 0x66, 0x84, 0x9b,
        0x64, 0x24, 0x4f, 0xfc, 0xe5, 0xec, 0xba, 0xaf, 0x33, 0xbd, 0x75, 0x1a,
        0x1a, 0xc7, 0x28, 0xd4, 0x5e, 0x6c, 0x61, 0x29, 0x6c, 0xdc, 0x3c, 0x01,
        0x23, 0x35, 0x61, 0xf4, 0x1d, 0xb6, 0x6c, 0xce, 0x31, 0x4a, 0xdb, 0x31,
        0x0e, 0x3b, 0xe8, 0x25, 0x0c, 0x46, 0xf0, 0x6d, 0xce, 0xea, 0x3a, 0x7f,
        0xa1, 0x34, 0x80, 0x57, 0xe2, 0xf6, 0x55, 0x6a, 0xd6, 0xb1, 0x31, 0x8a,
        0x02, 0x4a, 0x83, 0x8f, 0x21, 0xaf, 0x1f, 0xde, 0x04, 0x89, 0x77, 0xeb,
        0x48, 0xf5, 0x9f, 0xfd, 0x49, 0x24, 0xca, 0x1c, 0x60, 0x90, 0x2e, 0x52,
        0xf0, 0xa0, 0x89, 0xbc, 0x76, 0x89, 0x70, 0x40, 0xe0, 0x82, 0xf9, 0x37,
        0x76, 0x38, 0x48, 0x64, 0x5e, 0x07, 0x05 ];

  //encrypt
  ubyte[163] c;
  crypto_stream_xor(c.ptr, m.ptr, m.length, nonce.ptr, firstkey.ptr);
  assert(c[ 0..32] == rs);
  assert(c[32..$]  == [0x8e,0x99,0x3b,0x9f,0x48,0x68,0x12,0x73,0xc2,0x96,0x50,0xba,0x32,0xfc,0x76,0xce,0x48,0x33,0x2e,0xa7,0x16,0x4d,0x96,0xa4,0x47,0x6f,0xb8,0xc5,0x31,0xa1,0x18,0x6a,0xc0,0xdf,0xc1,0x7c,0x98,0xdc,0xe8,0x7b,0x4d,0xa7,0xf0,0x11,0xec,0x48,0xc9,0x72,0x71,0xd2,0xc2,0x0f,0x9b,0x92,0x8f,0xe2,0x27,0x0d,0x6f,0xb8,0x63,0xd5,0x17,0x38,0xb4,0x8e,0xee,0xe3,0x14,0xa7,0xcc,0x8a,0xb9,0x32,0x16,0x45,0x48,0xe5,0x26,0xae,0x90,0x22,0x43,0x68,0x51,0x7a,0xcf,0xea,0xbd,0x6b,0xb3,0x73,0x2b,0xc0,0xe9,0xda,0x99,0x83,0x2b,0x61,0xca,0x01,0xb6,0xde,0x56,0x24,0x4a,0x9e,0x88,0xd5,0xf9,0xb3,0x79,0x73,0xf6,0x22,0xa4,0x3d,0x14,0xa6,0x59,0x9b,0x1f,0x65,0x4c,0xb4,0x5a,0x74,0xe3,0x55,0xa5]);
//  writefln("%(0x%02x,%)", c[32..$]);
  //decrypt
  ubyte[163] m_dec;
  crypto_stream_xor(m_dec, c, nonce, firstkey);
  assert(m_dec == m);
  crypto_stream_xor(null, null, nonce, firstkey);
}

@safe
unittest {
  ubyte[crypto_stream_KEYBYTES] k;
  crypto_stream_keygen(k);
}