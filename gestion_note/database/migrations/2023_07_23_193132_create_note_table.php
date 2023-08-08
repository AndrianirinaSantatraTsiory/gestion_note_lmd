<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateNoteTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('note', function (Blueprint $table) {
            $table->increments('Id_Note')->unsigned();

            $table->unsignedInteger('Id_Mat');
            $table->foreign('Id_Mat')->references('Id_Mat')->on('matiere')->onDelete('cascade');

            $table->string('N_mat');
            $table->foreign('N_mat')->references('N_mat')->on('etudiant')->onDelete('cascade');

            $table->unsignedFloat('note');
            $table->string('Annee');
            $table->string('Niveau');
            $table->string('Parcours');
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
        Schema::dropIfExists('note');
    }
}
