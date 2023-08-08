<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateMatiereTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('matiere', function (Blueprint $table) {
            $table->increments('Id_Mat')->unsigned();
            $table->string('Designation');
            $table->unsignedFloat('Poids');

            $table->unsignedInteger('Id_UE');
            $table->foreign('Id_UE')->references('Id_UE')->on('ue')->onDelete('cascade');
            //$table->foreignId('Id_UE_ue')->constrained()->onDelete('cascade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('matiere');
    }
}
