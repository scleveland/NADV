class SequenceController < ApplicationController
  
  def index
  
  end
  
  def translate
    @seq =  Bio::Sequence::NA.new(params[:nuc_seq])
    @nuc_num = params[:nuc_num].to_i
    #@aaseq = @seq.translate
    @aaseq=""
    @aaseq_w_space=""
    window_size = 3
    step_size   = 3

    start_flag=false
    stop_flag = true
    # this will print all the codons as "aug", "gca", "ccg", "ucc", "aga"
    @seq.window_search(window_size, step_size) do |subseq|
      if subseq.translate == "M"
        start_flag = true
      end
      if subseq.translate == "*"
        if start_flag
          start_flag=false
           @aaseq_w_space = @aaseq_w_space + subseq.translate + '&nbsp;&nbsp;'#"\s\s"
           @aaseq = @aaseq + subseq.translate
        else
          @aaseq_w_space = @aaseq_w_space + '&nbsp;&nbsp;&nbsp;' #"\s\s\s"
        end
      elsif start_flag # && stop_flag
        @aaseq_w_space = @aaseq_w_space + subseq.translate + '&nbsp;&nbsp;' #"\s\s"
        @aaseq = @aaseq + subseq.translate
      else
        @aaseq_w_space = @aaseq_w_space + '&nbsp;&nbsp;&nbsp;' #"\s\s\s"
      end
    end

  end
  
  def download
    seq =  Bio::Sequence::NA.new(params[:nuc_seq])
    out_string =""
    aaseq=""
    window_size = 3
    step_size   = 3
    # this will print all the codons as "aug", "gca", "ccg", "ucc", "aga"
    start_flag=false
    stop_flag = true
    seq.window_search(window_size, step_size) do |subseq|
      #aaseq = aaseq + subseq.translate + "\s\s"
      
      if subseq.translate == "M"
        start_flag = true
      end
      if subseq.translate == "*"
        if start_flag
          start_flag=false
          aaseq = aaseq + subseq.translate + "\s\s"
        else
          aaseq = aaseq + "\s\s\s"
        end
      elsif start_flag # && stop_flag
        aaseq = aaseq + subseq.translate + "\s\s"
      else
        aaseq = aaseq + "\s\s\s"
      end
      
    end
    nuc_num = params[:nuc_num].to_i
    rows = (seq.length/nuc_num).abs 
    i = 0  
    # Create a new file and write to it   
    while i <= rows  do 
      out_string = out_string + ((nuc_num/3*i)+1).to_s + "\t" + aaseq[(nuc_num*i)..(nuc_num*i+nuc_num-1)] + "\n"
      out_string = out_string + ((nuc_num*i)+1).to_s + "\t" + seq.upcase[(nuc_num*i)..(nuc_num*i+nuc_num-1)] + "\n"
      i +=1  
    end 
    #render :file=> out_string
    send_data(out_string,
    :type => 'text/csv; charset=utf-8; header=present',
    :filename => "output.txt")
  end
  
  def new_download
    nuc_seq =  Bio::Sequence::NA.new(params[:nuc_seq])
    nuc_num = params[:nuc_num].to_i
    frame = params[:frame].to_i
    out_string =""
    aaseq=""
    if params[:reverse] == "true"
      out_string = create_translation_alignment_text(nuc_seq.complement, nuc_num, " ", frame)
    else
      out_string = create_translation_alignment_text(nuc_seq, nuc_num, " ", frame)
    end
    #render :file=> out_string
    send_data(out_string,
    :type => 'text/csv; charset=utf-8; header=present',
    :filename => "output.txt")
  end
  
  def new_results
    @seq =  Bio::Sequence::NA.new(params[:nuc_seq])
    out_string =""
    aaseq=""
    @nuc_num = params[:nuc_num].to_i
     @display1 = create_translation_alignment_html(@seq, @nuc_num, "_", 1)
     @display2 = create_translation_alignment_html(@seq, @nuc_num, "_", 2)
     @display3 = create_translation_alignment_html(@seq, @nuc_num, "_", 3)
    # @display1 = create_translation_alignment_html(seq, nuc_num, "&nbsp;", 1)
    #     @display2 = create_translation_alignment_html(seq, nuc_num, "&nbsp;", 2)
    #     @display3 = create_translation_alignment_html(seq, nuc_num, "&nbsp;", 3)
    #     
    @display4 = create_translation_alignment_html(@seq.complement, @nuc_num, "_", 1)
    @display5 = create_translation_alignment_html(@seq.complement, @nuc_num, "_", 2)
    @display6 = create_translation_alignment_html(@seq.complement, @nuc_num, "_", 3)
    #render :file=> out_string
    # send_data(out_string,
    # :type => 'text/csv; charset=utf-8; header=present',
    # :filename => "output.txt")
  end
  
  private
  
  def create_translation_alignment_text(nuc_seq, nuc_num, space_char, frame)
    seq = nuc_seq[frame-1..-1]
    aaseq=""
    for i in (1..frame-1) do
      aaseq=aaseq+space_char
    end
    aaseq = translate_nucleotides(seq,aaseq,space_char)
    outstring = map_nucleotide_and_aa_text(nuc_seq, aaseq, nuc_num)
    return outstring
  end
  
  
  def create_translation_alignment_html(nuc_seq, nuc_num, space_char, frame)
    seq = nuc_seq[frame-1..-1]
    aaseq=""
    for i in (1..frame-1) do
      aaseq=aaseq+space_char
    end
    debugger
    aaseq = translate_nucleotides(seq,aaseq,space_char)
    outstring = map_nucleotide_and_aa_html(nuc_seq, aaseq, nuc_num)
    return outstring
  end
  
  def translate_nucleotides(seq, aaseq, space_char)
    window_size = 3
    step_size   = 3
    start_flag=false
    stop_flag = true
    seq.window_search(window_size, step_size) do |subseq|
      if subseq.translate == "M"
        start_flag = true
      end
      if subseq.translate == "*"
        if start_flag
          start_flag=false
          aaseq = aaseq + subseq.translate + space_char + space_char
        else
          aaseq = aaseq + space_char + space_char + space_char
        end
      elsif start_flag # && stop_flag
        aaseq = aaseq + subseq.translate + space_char + space_char
      else
        aaseq = aaseq + space_char + space_char + space_char
      end
    end
    return aaseq
  end
  
  def map_nucleotide_and_aa_text(nuc_seq, aaseq, nuc_num)
    rows = (nuc_seq.length/nuc_num).abs 
    i = 0  
    out_string = ""
    # Create a new file and write to it   
    while i <= rows  do 
      out_string = out_string + ((nuc_num/3*i)+1).to_s + "\t" + aaseq[(nuc_num*i)..(nuc_num*i+nuc_num-1)] + "\n"
      out_string = out_string + ((nuc_num*i)+1).to_s + "\t" + nuc_seq.upcase[(nuc_num*i)..(nuc_num*i+nuc_num-1)] + "\n"
      i +=1  
    end
    return out_string
  end
  
  def map_nucleotide_and_aa_html(nuc_seq, aaseq, nuc_num)
    rows = (nuc_seq.length/nuc_num).abs 
    i = 0  
    out_string = "<table>"
    # Create a new file and write to it   
    while i <= rows  do 
      out_string= out_string + "<tr>"
      out_string = out_string + "<td>" + ((nuc_num*i)+1).to_s + "</td><td>&nbsp;&nbsp;</td><td>" + aaseq[(nuc_num*i)..(nuc_num*i+nuc_num-1)] + "</td></tr><tr>"
      out_string = out_string + "<td>" + ((nuc_num*i)+1).to_s + "</td><td>&nbsp;&nbsp;</td><td>" + nuc_seq.upcase[(nuc_num*i)..(nuc_num*i+nuc_num-1)] + "</td></tr>"
      i +=1  
    end
    out_string=out_string+"</table>"
    return out_string
  end
end