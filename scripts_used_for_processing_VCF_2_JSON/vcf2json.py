# Thanks to obigbando
# Ramanandan modified the original script to accomodate our project requirements.
# VCF.gz to JSON format

import gzip
import json
import sys
import os
from decimal import Decimal

##########################################################################
# literal constant
##########################################################################
VCF_FIELD_CHR = "chromosome"
VCF_FIELD_START = "start"
VCF_FIELD_ID = 'id'
VCF_FIELD_REF_ALLELE = "ref_allele"
VCF_FIELD_ALT_ALLELE = "alt_allele"
VCF_FIELD_QUALITY = 'qual'
VCF_FIELD_FILTER = 'filter'

DB_DEFAULT_FIELD = [
    VCF_FIELD_CHR,
    VCF_FIELD_START,
    VCF_FIELD_ID,
    VCF_FIELD_REF_ALLELE,
    VCF_FIELD_ALT_ALLELE,
    VCF_FIELD_QUALITY,
    VCF_FIELD_FILTER]
DB_DEFAULT_SIZE = len(DB_DEFAULT_FIELD)

INFO_PREFIX = 'info_'


def parse(l,sam):
    str_list = (l[0:-1]).split("\t", 8)
    sample = sam
    alt_count = 1
    allele_list = []

    # multi-allelic handling
    if str_list[4].find(",") != -1:
        allele_list = str_list[4].split(",")
        alt_count = len(allele_list)
    else:
        allele_list.append(str_list[4])

    # self.got_line_count_ += 1
    # self.allelic_count_[alt_count] += 1
    # self.create_record_count_ += alt_count
    output_record = parse_default_field(str_list, alt_count, allele_list,sample)

    info_dic = parse_info_field(str_list[DB_DEFAULT_SIZE])
    cast_record(alt_count, output_record, info_dic)
    return output_record[0]
    # prepare_record(alt_count, output_record)


# parsing first 7 default fields: chromosome, start, ID, ref_allele, alt_allele, QUAL, FILTER
def parse_default_field(str_list, alt_count, allele_list, sam):
    output_record = {}
    sample = ''.join(sam[0].split(".vcf.ann.vcf.gz"))
    for allele_index in range(0, alt_count):
        record = {}
        for index in range(0, DB_DEFAULT_SIZE):
            record["VCF_SAMPLE"] = sample
            if index == 1:
                record[VCF_FIELD_START] = int(str_list[index])
            elif index == 3:
                record[VCF_FIELD_REF_ALLELE] = str_list[index]
            elif index == 4:
                if allele_list[allele_index].find("<") != -1:
                    record[VCF_FIELD_ALT_ALLELE] = allele_list[allele_index]  # [1:-1]
            elif index == 5:
                if str_list[index] == '.':
                    record[VCF_FIELD_QUALITY] = 0
            else:
                record[DB_DEFAULT_FIELD[index]] = str_list[index]
        output_record[allele_index] = record
    return output_record


def parse_info_field(info_line):
    info_list = info_line.split(";")
    info_dic = {}
    for item_str in info_list:
        key_value_pair = item_str.split("=")
        # handle flag situation
        if len(key_value_pair) == 1:
            info_dic['{0}{1}'.format(INFO_PREFIX, key_value_pair[0].lower())] = ""

        else:
            if key_value_pair[0] == "AF":
               info_dic['{0}{1}'.format(INFO_PREFIX, key_value_pair[0].lower())] = float(key_value_pair[1])
            if key_value_pair[0] == "DP":
               info_dic['{0}{1}'.format(INFO_PREFIX, key_value_pair[0].lower())] = int(key_value_pair[1])
            if key_value_pair[0] != "ANN" or key_value_pair[0] != "AF" or key_value_pair[0] != "DP":
               info_dic['{0}{1}'.format(INFO_PREFIX, key_value_pair[0].lower())] = key_value_pair[1]
 
    ann_value = info_list[4].split("=")
    ann_list = ann_value[1].split(",")
    ann_tags = ann_list[0].split("|")
    info_dic['{0}{1}'.format(INFO_PREFIX, 'Allele')] = ann_tags[0]
    info_dic['{0}{1}'.format(INFO_PREFIX, 'SequenceOntology')] = ann_tags[1]
    info_dic['{0}{1}'.format(INFO_PREFIX, 'PutativeImpact')] = ann_tags[2]
    info_dic['{0}{1}'.format(INFO_PREFIX, 'GeneName')] = ann_tags[3]
    info_dic['{0}{1}'.format(INFO_PREFIX, 'GeneID')] = ann_tags[4]
    info_dic['{0}{1}'.format(INFO_PREFIX, 'FeatureType')] = ann_tags[5]
    info_dic['{0}{1}'.format(INFO_PREFIX, 'FeatureID')] = ann_tags[6]
    info_dic['{0}{1}'.format(INFO_PREFIX, 'TranscriptBiotype')] = ann_tags[7]
    info_dic['{0}{1}'.format(INFO_PREFIX, 'Rank')] = ann_tags[8]
    info_dic['{0}{1}'.format(INFO_PREFIX, 'DNAChange')] = ann_tags[9]
    info_dic['{0}{1}'.format(INFO_PREFIX, 'ProteinChange')] = ann_tags[10]
    info_dic['{0}{1}'.format(INFO_PREFIX, 'cDNA_len')] = ann_tags[11]
    info_dic['{0}{1}'.format(INFO_PREFIX, 'CDS_len')] = ann_tags[12]
    info_dic['{0}{1}'.format(INFO_PREFIX, 'Protein_len')] = ann_tags[13]

    return info_dic


def cast_record(alt_count, output_record, info_dic):
    output_key_dic_ = {}

    for allele_index in range(0, alt_count):
        for key in info_dic:
            if key in output_key_dic_:
                if output_key_dic_[key] == 'float':
                    if isinstance(info_dic[key], list):
                        output_record[allele_index][key] = float(info_dic[key][allele_index])
                    else:
                        output_record[allele_index][key] = float(info_dic[key])
                elif output_key_dic_[key] == 'int':
                    if isinstance(info_dic[key], list):
                        output_record[allele_index][key] = int(info_dic[key][allele_index])
                    else:
                        output_record[allele_index][key] = int(info_dic[key])
                elif output_key_dic_[key] == '' or output_key_dic_[key] == 'string':
                    output_record[allele_index][key] = info_dic[key]

                # exclusively for ESP TAC, EA_AC, AA_AC
                elif output_key_dic_[key] == 'vector<int>':
                    casted_vec = info_dic[key]
                    for index in range(0, len(casted_vec)):
                        casted_vec[index] = int(info_dic[key][index])
                    output_record[allele_index][key] = casted_vec

            else:
                output_record[allele_index][key] = info_dic[key]


def main(args):
    try:
        os.makedirs('{}'.format(args[2]))
    except FileExistsError:
        print('{} already exists'.format(args[2]))

    with gzip.open(args[1], 'r') as f:
        index = 0
        chunk_idx = 0
        sample = os.path.basename(args[1]).split(".vcf.ann.vcf.gz")
        cp = "{}/{}.chunk-{}.json".format(args[2], sample[0], chunk_idx)
        of = open(cp, 'w')
        for line in f:
            ll = line.decode('utf-8')
            if ll[0] == '#':
                continue
            idx = '{0:010d}'.format(index)
            obj = {"index": {"_index": "demo_table", "_type": "variant", "_id": idx}}
            of.write(json.dumps(obj))
            of.write('\n')
            of.write(json.dumps(parse(line.decode('utf-8'),sample)))
            of.write('\n')
            if index % 10000 == 9999:
                of.close()
                chunk_idx += 1
                cp = '{}/chunk-{}.json'.format(args[2], chunk_idx)
                of = open(cp, 'w')
            index += 1
        of.close()


if __name__ == '__main__':
    main(sys.argv)

