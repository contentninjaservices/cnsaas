#!/usr/bin/perl

use Digest::MD5 qw(md5 md5_hex md5_base64);
local ($buffer, @pairs, $pair, $name, $value, %FORM);
# Read in text
$ENV{'REQUEST_METHOD'} =~ tr/a-z/A-Z/;
if ($ENV{'REQUEST_METHOD'} eq "POST")
{
  read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
} else {
  $buffer = $ENV{'QUERY_STRING'};
}
# Split information into name/value pairs
@pairs = split(/&/, $buffer);
foreach $pair (@pairs)
{
  ($name, $value) = split(/=/, $pair);
  $value =~ tr/+/ /;
  $value =~ s/%(..)/pack("C", hex($1))/eg;
  $FORM{$name} = $value;
}
$repo     = $FORM{repo};

print "Content-type:text/html\r\n\r\n";
print "<html>";
print "<head>";
print "<title>ContentNinja as a Service</title>";
print "</head>";
print "<body>";

if ( $repo eq "" ) {

	print "<form action=\"index.pl\" method=\"post\">";
  # print "<textarea name=\"url\" rows=\"20\" cols=\"100\"></textarea>";
  print "Git Repo URL: <input type=\"text\" name=\"repo\">";
	print "<br><input type=\"submit\" name=\"Sent\" value=\"Add Youtube Links\"></form>";

} else {
	open(FH,"<count.asc") or die ("Kann nextID nicht auslesen. $@");
	my $count = <FH>;
	close FH;
	$count=$count+1;
	open(FH,">count.asc") or die ("Kann nextID nicht speichern. $@");
	print FH "$count";
	close FH;
	$hex = sprintf("%x",$count);
	printf "repo: %s, Hex: %s<br>", $repo, $hex;

}
