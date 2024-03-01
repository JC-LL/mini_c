module MiniC
  class DotGen
    def gen ast
      @code=Code.new
      @code << "digraph{"
      @code.indent=2
      @code << %{
      ordering=out;
      ranksep=.4;
      bgcolor="lightgrey";
      node [shape=box, fixedsize=false, fontsize=12, fontname="Helvetica-bold", fontcolor="blue"
         width=.25, height=.25, color="black", fillcolor="white", style="filled, solid, bold"];
      edge [arrowsize=.5, color="black", style="bold"]
      }
      rec_walk(ast)
      @code.indent=0
      @code << "}"
      @code.save_as "output.dot"
    end

    def rec_walk node
      id=node.object_id
      na=node.class.to_s.split("::").last #node name
      @code << "#{id}[label=\"#{na}\"]"
      node.instance_variables.each do |ivar|
        subnode=node.instance_variable_get(ivar)
        case subnode
        when Array
          subnode.each_with_index do |elem,idx|
            process_edge(node,elem,idx)
            rec_walk(elem) unless elem.is_a? Token
          end
        else
          process_edge(node,subnode)
          rec_walk(subnode) unless subnode.is_a? Token
        end
      end
    end

    def process_edge source,sink,idx=nil
      sink_id=sink.object_id
      sink_na=sink.class.to_s.split("::").last # sink name
      sink_na=sink.val if sink.is_a? Token
      edge_na=sink_na.downcase unless sink.is_a? Token
      edge_na+="[#{idx}]" if idx
      color=",color=red" if sink.is_a? Token
      @code << "#{sink_id}[label=\"#{sink_na}\"#{color}]"
      @code << "#{source.object_id}->#{sink_id}[label=\"#{edge_na}\"]"
    end
  end
end
