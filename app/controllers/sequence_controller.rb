class SequenceController < ApplicationController
  
  def index
  
  end
  def translate
    @seq =  Bio::Sequence::NA.new(params[:nuc_seq])
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
           @aaseq_w_space = @aaseq_w_space + subseq.translate + "__"
           @aaseq = @aaseq + subseq.translate
        else
          @aaseq_w_space = @aaseq_w_space + "___"
        end
      elsif start_flag # && stop_flag
        @aaseq_w_space = @aaseq_w_space + subseq.translate + "__"
        @aaseq = @aaseq + subseq.translate
      else
        @aaseq_w_space = @aaseq_w_space + "___"
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
    nuc_num = 60
    rows = (seq.length/nuc_num).abs 
    i = 0  
    # Create a new file and write to it   
    while i < rows  do 
      out_string = out_string + ((nuc_num/3*i)+1).to_s + "\t" + aaseq[(nuc_num*i)..(nuc_num*i+nuc_num-1)] + "\n"
      out_string = out_string + ((nuc_num*i)+1).to_s + "\t" + seq.upcase[(nuc_num*i)..(nuc_num*i+nuc_num-1)] + "\n"
      i +=1  
    end 
    #render :file=> out_string
    send_data(out_string,
    :type => 'text/csv; charset=utf-8; header=present',
    :filename => "output.txt")
  end
end