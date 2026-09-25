#!usr/bin/perl
# [original] cluster: <path>/format_diagnosis.pl (gFACs helper)
##################################################################################################################################################################
# About this script:
#	This script is designed to take in your format and tell you about it.
##################################################################################################################################################################
#ARGV[0] --> format input
#Output is printed to screen

print "Format", "\t",
	"partition", "\t",
	"gene", "\t",
	"mRNA", "\t",
	"exon", "\t",
	"CDS", "\t",
	"intron", "\t",
	"start_codon", "\t",
	"stop_codon", "\t", 
	"Other third column", "\t",
	"\n";

open (INPUT, $ARGV[0]) or die "Cannot open the input file!!!";
	$partition = "no"; $count_partition = 0;
	$count_mRNA = 0; $mRNA = "no";
	$count_gene = 0; $gene = "no";
	$count_exon = 0; $exon = "no";
	$count_CDS = 0; $CDS = "no";
	$count_intron = 0; $intron = "no";
	$count_start = 0; $start = "no";
	$count_stop = 0; $stop = "no";

while ($line = <INPUT>){
	$line =~ s/\s+$//;

	@tab = split "\t", $line;

	if ($tab[0] =~ /\#\#\#/){ $count_partition++; $partition = "yes";}
	if ($tab[2] =~ /^mRNA$/){ $count_mRNA++; $mRNA = "yes";}
	if ($tab[2] =~ /^gene$/){ $count_gene++; $gene = "yes";}
	if ($tab[2] =~ /^exon$/){ $count_exon++; $exon = "yes";}
	if ($tab[2] =~ /^CDS$/ or $tab[2] =~ /^cds$/){ $count_CDS++; $CDS = "yes";}
	if ($tab[2] =~ /^intron$/){ $count_intron++; $intron = "yes";}
	if ($tab[2] =~ /^start_codon$/){ $count_start++; $start = "yes";}
	if ($tab[2] =~ /^stop_codon$/){ $count_stop++; $stop = "yes";}
	if ($tab[2] !~ /^mRNA$/ and $tab[2] !~ /^gene$/ and $tab[2] !~ /^exon$/ and $tab[2] !~ /^CDS$/ and $tab[2] !~ /^intron$/ 
		and $tab[2] !~ /^cds$/ and $tab[2] !~ /^start_codon$/ and $tab[2] !~ /^stop_codon$/){$else{$tab[2]}++;}
}
foreach $else (keys %else){push @else, $else}
close INPUT;
print "Your input", "\t",
	$partition, "\[$count_partition\]",
	"\t", $gene, "\[$count_gene\]",
	"\t", $mRNA, "\[$count_mRNA\]",
	"\t", $exon, "\[$count_exon\]",
	"\t", $CDS, "\[$count_CDS\]",
	"\t", $intron, "\[$count_intron\]",
	"\t", $start, "\[$count_start\]",
	"\t", $stop, "\[$count_stop\]",
	"\t", "\(", "@else", "\)",
	"\n";	

##################################################################################################################################################################
##################################################################################################################################################################
# What came first? Orange the fruit or orange the color? The fruit! The color for orange was not used until 1512 and was first mentioned in a will!
